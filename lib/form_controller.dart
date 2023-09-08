
import 'package:dynamic_forms/field_state.dart';
import 'package:flutter/cupertino.dart';
import 'utils.dart';

class FormModel {

  static const String FORM_KEY = "form"; // Field name
  static const String FORM_TITLE_KEY = "title"; // String?
  static const String FORM_DESC_KEY = "description"; // String?
  static const String FORM_FIELDS_KEY = "fields"; // List<List<Map<String, dynamic>>>

  /// The form key is the json key of the form, if it is null it means that this form is the parent
  /// All subforms must have a key defined, where a subform will become a map

  final String? key;

  final String? title;
  final String? desc;
  final List<List<DynamicFormFieldState>> _fields;
  late final List<FormModel>? subforms;

  List<List<DynamicFormFieldState>> get fieldsMatrix => _fields;

  /// Return the fields in the main form only (Not the fields from the subform)
  List<DynamicFormFieldState> get expandedMainFields => _fields.expand((e) => e).toList();

  List<DynamicFormFieldState> get allFields {
    final List<DynamicFormFieldState> data = List.from(expandedMainFields);
    for (final FormModel subform in (subforms ?? [])) {
      data.addAll(subform.allFields);
    }
    return data;
  }

  FormModel._({
    required this.key,
    this.title,
    this.desc,
    this.subforms,
    required List<List<DynamicFormFieldState>> fields,
  }) : _fields = fields {
    var duplicates = _fields.expand((element) => element).map((e) => e.key).toList().getDuplicates();
    assert(duplicates.isEmpty, "As chaves $duplicates estão repetidas ao menos uma vez");
    assert(key == null || (subforms?.every((e) => e.key != null) ?? true),
    "The parent form key must be null while all subforms keys must be defined");
  }

  FormModel({
    required String? key,
    String? title,
    String? desc,
    List<FormModel>? subforms,
    required List<List<DynamicFormFieldState>> fields,
  }) : this._(
      key: key,
      fields: fields,
      title: title,
      desc: desc,
      subforms: subforms,
  );

  FormModel.singleField({
    String? title,
    String? desc,
    required DynamicFormFieldState field,
  }) : this._(
    key: field.key,
    fields: [[field]],
    title: title,
    desc: desc,
    subforms: null,
  );


  FormModel.vertical({
    required String? key,
    String? title,
    String? desc,
    List<FormModel>? subforms,
    required List<DynamicFormFieldState> fields}) : this._(
      key: key,
      title: title,
      desc: desc,
      subforms: subforms,
      fields: fields.map((field) => [field]).toList(),
  );

  FormModel copyWith({
    String? key,
    String? title,
    String? desc,
    List<FormModel>? subforms,
    List<List<DynamicFormFieldState>>? fields,
  }) => FormModel(
      key: key ?? this.key,
      fields: fields ?? this.fieldsMatrix,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      subforms: subforms ?? this.subforms,
  );

  factory FormModel.fromJSON(Map<String, dynamic> data) {

    var fieldsAsMaps =  (data[FORM_FIELDS_KEY] as List<List<Map<String, dynamic>>>);
    var mappedFields = fieldsAsMaps.map((rows) => rows.map((column) => DynamicFormFieldState.fromJSON(column)).toList()).toList();

    return FormModel(
        key: data[FORM_KEY],
        title: data[FORM_TITLE_KEY],
        desc: data[FORM_DESC_KEY],
        fields: mappedFields,
    );
  }

  /// Maps the form inputs as JSON structure
  Map<String, dynamic> toJSON() {
    var data = Map.fromEntries(expandedMainFields.map((e) => MapEntry(e.key, e.value)));
    for (FormModel subform in subforms ?? []) {
      var fields = subform.expandedMainFields;

      // Reduce single fields where the json structure looks like
      // [fieldKey: {fieldKey: fieldValue}] to [fieldKey: fieldValue]
      var isSingleField = fields.length == 1 && fields[0].key == subform.key;

      data[subform.key!] = isSingleField
          ? fields[0].value
          : subform.toJSON();
    }
    return data;
  }

  DynamicFormFieldState<T> findByKey<T>(String key) {

    try {
      return fieldsMatrix.expand((element) => element).singleWhere((element) => element.key == key) as DynamicFormFieldState<T>;
    } catch (_) {
      throw Exception("There is no $key value on the current controller");
    }

  }

}

abstract interface class FormController {

  List<DynamicFormFieldState> get fields;
  List<DynamicFormFieldState> get requiredFields;
  List<DynamicFormFieldState> get optionalFields;

  bool validate({bool validateInBatch = true});

  void clearErrors();
  Map<String, dynamic> toJSON();
}

class SingleFormController implements FormController {

  FormModel form;
  SingleFormController({required this.form});

  /// Build your forms from a JSON structure
  factory SingleFormController.fromJSON(Map<String, dynamic> data) {
    return SingleFormController(form: FormModel.fromJSON(data));
  }

  @override
  List<DynamicFormFieldState> get fields => form.allFields;

  @override
  List<DynamicFormFieldState> get requiredFields =>  fields.where((element) => element.isRequired).toList();

  @override
  List<DynamicFormFieldState> get optionalFields =>  fields.where((element) => !element.isRequired).toList();

  @override
  bool validate({bool validateInBatch = true}) {

    if (validateInBatch) {
      for (var e in requiredFields) {
        e.validate();
      }
      for (var e in optionalFields.where((e) => e.value != null)) {
        e.validate();
      }
    }

    bool requiredAreReady = requiredFields.every((element) => element.isValid);
    bool optionalFieldsAreReady = optionalFields.where((element) => element.value != null).every((element) => element.isValid);
    return requiredAreReady && optionalFieldsAreReady;
  }

  @override
  void clearErrors() {
    for (var e in fields) {
      e.error = null;
    }
  }

  // Todo allow deep tree search
  DynamicFormFieldState findByKey(String key) {

    try {
      return fields.singleWhere((element) => element.key == key);
    } catch (_) {
      throw Exception("There is no $key value on the current controller");
    }

  }

  void addListenersByKey(Map<String,void Function(DynamicFormFieldState)> listenersMap) {
    for (final entry in listenersMap.entries) {
      var node = findByKey(entry.key);
      node.addListener(() => entry.value(node));
    }
  }

  @override
  Map<String, dynamic> toJSON() => form.toJSON();

}

class MultipleFormController extends ChangeNotifier implements FormController {

  MultipleFormController({
      required List<FormModel> forms,
  }) : _forms = forms, assert(forms.every((element) => element.key != null && element.key!.isNotEmpty)
      && forms.map((e) => e.key!).toList().getDuplicates().isEmpty, "There is some duplicated form keys");

  final List<FormModel> _forms;
  List<FormModel> get forms => _forms;

  @override
  List<DynamicFormFieldState> get fields => forms.expand((form) => form.allFields).toList();

  @override
  List<DynamicFormFieldState> get requiredFields =>  fields.where((element) => element.isRequired).toList();

  @override
  List<DynamicFormFieldState> get optionalFields =>  fields.where((element) => !element.isRequired).toList();

  @override
  bool validate({bool validateInBatch = true}) {

    if (validateInBatch) {
      for (var e in requiredFields) {
        e.validate();
      }
      for (var e in optionalFields.where((e) => e.value != null)) {
        e.validate();
      }
    }

    bool requiredAreReady = requiredFields.every((element) => element.isValid);
    bool optionalFieldsAreReady = optionalFields.where((element) => element.value != null).every((element) => element.isValid);
    return requiredAreReady && optionalFieldsAreReady;
  }

  @override
  void clearErrors() {
    for (var e in forms.expand((e) => e.allFields)){
      e.error = null;
    }
  }

  FormModel add(FormModel form) {
    assert(form.key != null && form.key!.isNotEmpty, "Only root forms can have a null key");
    assert(!_forms.map((e) => e.key).contains(form.key), "There is already a form by the key ${form.key}");
    _forms.add(form);
    notifyListeners();
    return form;
  }

  void insert(int i, FormModel form) {
    if (i >= 0 && i <= _forms.length) {
      _forms.insert(i, form);
      notifyListeners();
    }
  }

  void removeByKey(String key) {
    _forms.removeWhere((form) => form.key == key);
    notifyListeners();
  }

  void removeByIndex(int i) {

    if (i >= 0 && i < _forms.length) {
      _forms.removeAt(i);
      notifyListeners();
    }
  }

  void popUntilKey(String key, {bool inclusive = false}) {
    final reversedForms = _forms.reversed.toList();
    final index = reversedForms.indexWhere((form) => form.key == key);

    if (index != -1) {
      final indexToRemove = _forms.length - 1 - index;

      if (inclusive) {
        _forms.removeRange(indexToRemove, _forms.length);
      } else {
        _forms.removeRange(indexToRemove + 1, _forms.length);
      }

      notifyListeners();
    }
  }

  FormModel getByKey(String key) {

    try {
      return _forms.firstWhere((form) => form.key == key);
    } catch (_) {
      throw Exception("There is no $key form in this controller");
    }
  }

  /*
  DynamicFormFieldState getFieldByKey(String fieldKey) {

    try {
      return forms
          .expand((FormModel parent) => "${parent.key}.${}");
    } catch (_) {
      throw Exception("There is no $key form in this controller");
    }
  }

   */

  @override
  Map<String, dynamic> toJSON() {
    // TODO: implement toJSON
    throw UnimplementedError();
  }


}