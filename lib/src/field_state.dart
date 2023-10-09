import 'package:dynamic_forms/src/form_field_types/autocompleter_field.dart';
import 'package:flutter/material.dart';
import 'form_field_configuration.dart';

import 'form_field_types/dropdown_field.dart';
import 'form_field_types/switcher_field.dart';
import 'form_field_types/text_fields/text_field_base.dart';
import 'form_field_types/checkbox_field.dart';
import 'form_field_types/expandable_field.dart';
import 'form_field_types/table_field/table_field_state.dart';
import 'form_field_types/file_field.dart';

export 'form_field_types/dropdown_field.dart';
export 'form_field_types/switcher_field.dart';
export 'form_field_types/text_fields/text_field_base.dart';
export 'form_field_types/checkbox_field.dart';
export 'form_field_types/expandable_field.dart';
export 'package:file_picker/file_picker.dart';
export 'form_field_types/file_field.dart';
export 'form_field_types/table_field/table_field_state.dart';
export 'form_field_types/autocompleter_field.dart';

/// This is the base class of any form field state
abstract base class DynamicFormFieldState<T> extends ChangeNotifier {

  static const String KEY_REQUIRED = "required";
  static const String KEY_KEY = "key";
  static const String KEY_INITIAL_VALUE = "default_value";
  static const String KEY_ENABLED = "enabled";

  DynamicFormFieldState({
    required this.key,
    required this.configuration,
    this.jsonEntryMapper,
    T? initialValue,
    bool? isRequired,
    bool? enabled,
    void Function(T?)? callback,
  }) :
        _error = null,
        _enabled = enabled ?? true,
        _value = initialValue,
        isRequired = isRequired ?? true {
    if (callback != null) {
      listenItself(callback);
    }
  }


  final String key;
  final FormFieldConfiguration configuration;
  final dynamic Function(T?)? jsonEntryMapper;

  /// An required field will be validated (Default is true)
  final bool isRequired;

  T? _value;
  String? _error;
  bool _enabled;

  T? get value => _value;
  String? get error => _error;
  bool get enabled => _enabled;

  bool get hasError => _error != null && _error!.isNotEmpty;

  set value(T? value) {
    if (value == _value) return;
    _value = value;
    notifyListeners();
  }

  set error(String? value) {
    if (value == _error) return;
    _error = value;
    notifyListeners();
  }

  set enabled(bool value) {
    if (value == _enabled) return;
    _enabled = value;
    notifyListeners();
  }

  bool validator(T? v);

  /// Only returns if the field is valid or not, it does not change the state to error if it is not
  /// A non required field will be validated if it is not null
  bool get isValid => isRequired || value != null ? validator(value) : true;

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

  /// If the [autoFillValue] is valid, the current field state value will be updated
  void autofill(T? autoFillValue) {
    if (_value != autoFillValue && validator(autoFillValue)) {
      if (validator(autoFillValue)) {
        value = autoFillValue;
      }
    }
  }


  /// How the value will be parsed as a json entry
  /// Useful when you need to override the output data type, example:
  /// transform a [DateTime] value into a [Timestamp] to firestore
  MapEntry<String, dynamic> asJsonEntry() => MapEntry(key, jsonEntryMapper != null ? jsonEntryMapper!(value) : value);


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
      case FormFieldType.switcher: throw SwitchFieldState.fromJSON(json) as DynamicFormFieldState<T>;
      case FormFieldType.dropdownMenu: return DropdownFieldState.fromJSON(json) as DynamicFormFieldState<T>;
      case FormFieldType.file: return FilePickerFieldState.fromJSON(json) as DynamicFormFieldState<T>;
      case FormFieldType.expandable: return ExpandableFieldState.fromJSON(json) as DynamicFormFieldState<T>;
      case FormFieldType.table: return TableFieldState.fromJSON(json) as DynamicFormFieldState<T>;
      case FormFieldType.autocomplete: return AutocompleteFieldState.fromJSON(json) as DynamicFormFieldState<T>;
    }
    
  }

   

}

