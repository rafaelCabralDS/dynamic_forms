

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
  final List<FormModel>? subforms;

  List<List<DynamicFormFieldState>> get fields => _fields;

  FormModel._({
    this.key,
    this.title,
    this.desc,
    this.subforms,
    required List<List<DynamicFormFieldState>> fields,
  }) : _fields = fields {
    var duplicates = _fields.expand((element) => element).map((e) => e.key).toList().getDuplicates();
    assert(duplicates.isEmpty, "As chaves $duplicates estão repetidas ao menos uma vez");
    
    assert(key == null || (subforms?.every((e) => e.key != null) ?? true), "The parent form key must be null while all subforms keys must be defined");
  }

  FormModel({
    String? key,
    String? title,
    String? desc,
    List<FormModel>? subforms,
    required List<List<DynamicFormFieldState>> fields,
  }) : this._(fields: fields, title: title, desc: desc, subforms: subforms, key: key);

  FormModel.singleField({
    this.title,
    this.desc,
    required DynamicFormFieldState field,
  }) : _fields = [[field]], key = field.key, subforms = null;


  FormModel.vertical({
    String? key,
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
    String? title,
    String? desc,
    List<FormModel>? subforms,
    List<List<DynamicFormFieldState>>? fields,
  }) => FormModel(
      fields: fields ?? this.fields,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      subforms: subforms ?? this.subforms,
  );

  factory FormModel.fromJSON(Map<String, dynamic> data) {

    var fieldsAsMaps =  (data[FORM_FIELDS_KEY] as List<List<Map<String, dynamic>>>);
    var mappedFields = fieldsAsMaps.map((rows) => rows.map((column) => DynamicFormFieldState.fromJSON(column)).toList()).toList();

    return FormModel(
        title: data[FORM_TITLE_KEY],
        desc: data[FORM_DESC_KEY],
        fields: mappedFields,
    );
  }

  /// Maps a form into a JSON structure
  Map<String, dynamic> toJSON() {
    Iterable<MapEntry<String, dynamic>> fieldsEntries = fields.expand((element) => element).map((e) => e.asJsonEntry());
    Iterable<MapEntry<String, dynamic>> childrenEntries = (subforms ?? []).map((e) => MapEntry(e.key!, e.toJSON())).toList();

    return {
      ...Map.fromEntries(fieldsEntries),
      ...Map.fromEntries(childrenEntries),

    };
  }

  DynamicFormFieldState<T> findByKey<T>(String key) {

    try {
      return fields.expand((element) => element).singleWhere((element) => element.key == key) as DynamicFormFieldState<T>;
    } catch (_) {
      throw Exception("There is no $key value on the current controller");
    }

  }


}

abstract interface class FormController {

  List<List<DynamicFormFieldState>> get fields;
  List<DynamicFormFieldState> get requiredFields;
  List<DynamicFormFieldState> get optionalFields;

  bool validate({bool validateInBatch = true});

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
  List<List<DynamicFormFieldState>> get fields => form.fields;

  @override
  List<DynamicFormFieldState> get requiredFields =>  fields.expand((element) => element).where((element) => element.isRequired).toList();

  @override
  List<DynamicFormFieldState> get optionalFields =>  fields.expand((element) => element).where((element) => !element.isRequired).toList();

  // Todo allow deep tree search
  DynamicFormFieldState findByKey(String key) {

    try {
      return fields.expand((element) => element).singleWhere((element) => element.key == key);
    } catch (_) {
      throw Exception("There is no $key value on the current controller");
    }

  }

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

  void addListenersByKey(Map<String,void Function(DynamicFormFieldState)> listenersMap) {
    for (final entry in listenersMap.entries) {
      var node = findByKey(entry.key);
      node.addListener(() => entry.value(node));
    }
  }

  @override
  Map<String, dynamic> toJSON() {
    // TODO: implement toJSON
    throw UnimplementedError();
  }

}

class MultipleFormController extends ChangeNotifier implements FormController {

  MultipleFormController({
      required List<FormModel> forms,
  }) : _forms = forms, assert(forms.every((element) => element.key != null) && forms.map((e) => e.key!).toList().getDuplicates().isEmpty);

  final List<FormModel> _forms;
  List<FormModel> get forms => _forms;

  @override
  List<List<DynamicFormFieldState>> get fields => forms.expand((form) => form.fields).toList();

  @override
  List<DynamicFormFieldState> get requiredFields =>  fields.expand((element) => element).where((element) => element.isRequired).toList();

  @override
  List<DynamicFormFieldState> get optionalFields =>  fields.expand((element) => element).where((element) => !element.isRequired).toList();

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

  FormModel add(FormModel form) {
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
      var e = _forms.removeAt(i);
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

  /*
  void popUntilIndex(int i, {bool inclusive = false}) {
    if (i >= 0 && i < _forms.length) {
      final indexToRemove = inclusive ? i : i-1;
      final endIndex = _forms.length - indexToRemove;

      if (endIndex < _forms.length) {
        _forms.removeRange(endIndex, _forms.length);
        notifyListeners();
      }
    }
  }
   */

  FormModel getByKey(String key) {

    try {
      return _forms.firstWhere((form) => form.key == key);
    } catch (_) {
      throw Exception("There is no $key form in this controller");
    }

  }

  @override
  Map<String, dynamic> toJSON() {
    // TODO: implement toJSON
    throw UnimplementedError();
  }


}