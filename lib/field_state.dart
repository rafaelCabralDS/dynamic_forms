import 'package:dynamic_forms/form_field_configuration.dart';
import 'package:dynamic_forms/form_field_types/text_fields/text_field_base.dart';
import 'package:flutter/material.dart';

export 'form_field_types/text_fields/text_field_base.dart';

/// This is the base class of any form field state
abstract base class DynamicFormFieldState<T> extends ChangeNotifier {

  static const String KEY_REQUIRED = "required";
  static const String KEY_KEY = "key";
  static const String KEY_INITIAL_VALUE = "default_value";

  DynamicFormFieldState({
    required this.key,
    required this.configuration,
    T? initialValue,
    bool? isRequired,
  }) :
        _error = null,
        _value = initialValue,
        isRequired = isRequired ?? true;

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

  /// Only returns if the field is valid or not, it does not change the state to error if it is not
  bool get isValid;

  /// A method to override if you want to auto update the error state if the field is not valid
  bool validate([String invalidMsg = "Campo inválido"]) {
    if (value == null) return false;
    if (isValid && error != null) error = null;
    if (!isValid && error == null) error = invalidMsg;

    return isValid;
  }

  /// Clear any error and value from the field
  void reset() {
    _value = null;
    _error = null;
    notifyListeners();
  }

  /// Similar to addListener, but take a function that gets its own current state value
  void listenItself(void Function(T? stateValue) listener) {
    addListener(() {
      listener(value);
    });
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
      case FormFieldType.checkbox: return CheckboxFieldState.fromJSON(json) as DynamicFormFieldState<T>;
      case FormFieldType.switcher: throw UnimplementedError();
      case FormFieldType.dropdownMenu: return DropdownFieldState.fromJSON(json) as DynamicFormFieldState<T>;
    }


  }

}

