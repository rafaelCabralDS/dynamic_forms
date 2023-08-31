import 'package:dynamic_forms/form_field_configuration.dart';
import 'package:flutter/material.dart';



/// This is the base class of any form field state
abstract base class FormFieldState<T> extends ChangeNotifier {

  FormFieldState({
    required this.key,
    required this.configuration,
    T? initialValue,
    List<FormFieldState>? dependencies,
    this.isRequired = true,
  }) : _error = null, _value = initialValue, _dependencies = dependencies ?? const [];

  final String key;
  final FormFieldConfiguration configuration;

  /// An required field will be validated (Default is true)
  final bool isRequired;

  /// If a field depends on other, it will only be available once all [dependencies] are valid
  final List<FormFieldState> _dependencies;

  T? _value;
  String? _error;

  T? get value => _value;
  String? get error => _error;

  bool get hasError => _error != null && _error!.isNotEmpty;
  bool get enabled => _dependencies.every((element) => element.isValid());

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
  factory FormFieldState.fromJSON(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

}

final class TextFieldState extends FormFieldState<String> {

  TextFieldState({
    required super.key,
    required super.initialValue,
    required super.configuration,
    super.isRequired,
  }) : super();

  @override
  TextFormFieldConfiguration get configuration => super.configuration as TextFormFieldConfiguration;


  /// A normal text field is always valid
  @override
  bool isValid() => true;

}

final class EmailFieldState extends FormFieldState<String> {

  static const Pattern _pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final RegExp regex = RegExp(_pattern as String);

  EmailFieldState({
    required super.key,
    required super.initialValue,
    required super.configuration,
    super.isRequired,
  });

  /// A normal text field is always valid
  @override
  bool isValid() {
    if (value == null) return false;
    if (!regex.hasMatch(value!)) {
      error = 'Email inválido';
      return false;
    } else {
      error = null;
      return true;
    }
  }

}

