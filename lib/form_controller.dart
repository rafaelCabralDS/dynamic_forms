

import 'package:dynamic_forms/field_state.dart';
import 'utils.dart';

class FormModel {

  static const String FORM_KEY = "form"; // Field name
  static const String FORM_TITLE_KEY = "title"; // String?
  static const String FORM_DESC_KEY = "description"; // String?
  static const String FORM_FIELDS_KEY = "fields"; // List<List<Map<String, dynamic>>>

  final String? title;
  final String? desc;
  final List<List<DynamicFormFieldState>> _fields;

  List<List<DynamicFormFieldState>> get fields => _fields;

  FormModel({
    this.title,
    this.desc,
    required List<List<DynamicFormFieldState>> fields}) : _fields = List.from(fields) {
    var duplicates = _fields.expand((element) => element).map((e) => e.key).toList().getDuplicates();
    assert(duplicates.isEmpty, "As chaves $duplicates estão repetidas ao menos uma vez");
  }

  FormModel.vertical({
    this.title,
    this.desc,
    required List<DynamicFormFieldState> fields}) : _fields = fields.map((e) => [e]).toList() {
    var duplicates = _fields.expand((element) => element).map((e) => e.key).toList().getDuplicates();
    assert(duplicates.isEmpty, "As chaves $duplicates estão repetidas ao menos uma vez");
  }

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
  Map<String, dynamic> toJSON() => Map.fromEntries(fields.expand((element) => element).map((e) => e.asJsonEntry()));

}

class DynamicFormController {

  FormModel form;
  DynamicFormController({required this.form});

  /// Build your forms from a JSON structure
  factory DynamicFormController.fromJSON(Map<String, dynamic> data) {
    return DynamicFormController(form: FormModel.fromJSON(data));
  }

  List<List<DynamicFormFieldState>> get fields => form.fields;
  List<DynamicFormFieldState> get requiredFields =>  fields.expand((element) => element).where((element) => element.isRequired).toList();
  List<DynamicFormFieldState> get optionalFields =>  fields.expand((element) => element).where((element) => !element.isRequired).toList();

  DynamicFormFieldState findByKey(String key) {

    try {
      return fields.expand((element) => element).singleWhere((element) => element.key == key);
    } catch (_) {
      throw Exception("There is no $key value on the current controller");
    }

  }

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


}