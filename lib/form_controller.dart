

import 'package:dynamic_forms/field_state.dart';

class FormController {

  FormController({required List<List<FormFieldState>> fields}) : _fields = List.from(fields);
  FormController.vertical({required List<FormFieldState> fields}) : _fields = fields.map((e) => [e]).toList();

  final List<List<FormFieldState>> _fields;


  List<List<FormFieldState>> get fields => _fields;
  List<FormFieldState> get requiredFields =>  fields.expand((element) => element).where((element) => element.isRequired).toList();
  List<FormFieldState> get optionalFields =>  fields.expand((element) => element).where((element) => !element.isRequired).toList();

  FormFieldState findByKey(String key) => fields.expand((element) => element).singleWhere((element) => element.key == key);

  bool validate() {
    bool requiredAreReady = requiredFields.every((element) => element.isValid());
    bool optionalFieldsAreReady = optionalFields.where((element) => element.value != null).every((element) => element.isValid());
    return requiredAreReady && optionalFieldsAreReady;
  }

  Map<String, dynamic> toJSON() => Map.fromEntries(fields.expand((element) => element).map((e) => e.asJsonEntry()));


}