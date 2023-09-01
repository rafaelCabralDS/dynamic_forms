import 'package:dynamic_forms/form_field_configuration.dart';
import 'package:dynamic_forms/form_field_types/text_field.dart';
import 'package:dynamic_forms/form_field_types/text_field_base.dart';
import 'package:flutter/material.dart';



/// This is the base class of any form field state
abstract base class DynamicFormFieldState<T> extends ChangeNotifier {

  static const String KEY_REQUIRED = "required";
  static const String KEY_KEY = "key";
  static const String KEY_INITIAL_VALUE = "default_value";

  DynamicFormFieldState({
    required this.key,
    required this.configuration,
    T? initialValue,

    this.isRequired = true,
  }) : _error = null, _value = initialValue;

  final String key;
  final FormFieldConfiguration configuration;

  /// An required field will be validated (Default is true)
  final bool isRequired;

  T? _value;
  String? _error;

  T? get value => _value;
  String? get error => _error;

  bool get hasError => _error != null && _error!.isNotEmpty;
 // bool get enabled => _dependencies.every((element) => element.isValid());

  set value(T? value) {
    _value = value;
    notifyListeners();
  }

  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  bool isValid();

  /// Clear any error and value from the field
  void reset() {
    _value = null;
    _error = null;
    notifyListeners();
  }

  MapEntry<String, T?> asJsonEntry() => MapEntry(key, value);

  /// Translates a map in the format
  /// { KEY : key_name, }
  /// into a FormFieldState.
  ///
  /// This can be useful for changing and building forms just by adding/removing/editing
  /// a database json file that represents the required form fields
  factory DynamicFormFieldState.fromJSON(Map<String, dynamic> json) {

    var fieldType = FormFieldType.fromString(json[FormFieldConfiguration.KEY_FIELD_TYPE]);

    switch (fieldType) {
      case FormFieldType.textField: return BaseTextFieldState.fromJSON(json) as DynamicFormFieldState<T>;
      case FormFieldType.checkbox: throw UnimplementedError();
      case FormFieldType.switcher: throw UnimplementedError();
      case FormFieldType.dropdownMenu: throw UnimplementedError();
    }


  }

}

