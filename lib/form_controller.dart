

import 'package:dynamic_forms/field_state.dart';


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
    required List<List<DynamicFormFieldState>> fields}) : _fields = List.from(fields);

  FormModel.vertical({
    this.title,
    this.desc,
    required List<DynamicFormFieldState> fields}) : _fields = fields.map((e) => [e]).toList();

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

class FormController {

  FormModel form;
  FormController({required this.form});

  /// Build your forms from a JSON structure
  factory FormController.fromJSON(Map<String, dynamic> data) {
    return FormController(form: FormModel.fromJSON(data));
  }

  List<List<DynamicFormFieldState>> get fields => form.fields;
  List<DynamicFormFieldState> get requiredFields =>  fields.expand((element) => element).where((element) => element.isRequired).toList();
  List<DynamicFormFieldState> get optionalFields =>  fields.expand((element) => element).where((element) => !element.isRequired).toList();

  DynamicFormFieldState findByKey(String key) => fields.expand((element) => element).singleWhere((element) => element.key == key);

  bool validate({bool validateInBatch = true}) {

    if (validateInBatch) {
      for (var e in requiredFields) {
        e.isValid();
      }
      for (var e in optionalFields.where((e) => e.value != null)) {
        e.isValid();
      }
    }

    bool requiredAreReady = requiredFields.every((element) => element.isValid());
    bool optionalFieldsAreReady = optionalFields.where((element) => element.value != null).every((element) => element.isValid());
    return requiredAreReady && optionalFieldsAreReady;
  }


}