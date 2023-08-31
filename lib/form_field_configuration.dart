
import 'package:flutter/material.dart';

enum FormFieldType {textField, switcher, checkbox, dropdownMenu}

/// Describe properties about a form field
base class FormFieldConfiguration {

  final FormFieldType formType;

  /// If not defined, the field [key] value will be used
  final String? label;


  const FormFieldConfiguration({
    required this.formType,
    this.label,
  });

  factory FormFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}

final class TextFormFieldConfiguration extends FormFieldConfiguration {

  /// If not defined, the label value will be used
  final String? hint;

  /// The input data type (Default is text)
  final TextInputType inputType;

  /// Use obscure text (Default is false)
  final bool obscure;

  const TextFormFieldConfiguration({
    super.label,
    this.hint,
    this.inputType = TextInputType.text,
    this.obscure = false,
  }) : super(
    formType: FormFieldType.textField,
  );

  static const TextFormFieldConfiguration factory = TextFormFieldConfiguration();

  factory TextFormFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}

final class SwitcherFieldConfiguration extends FormFieldConfiguration {

  const SwitcherFieldConfiguration({
    super.label,
  }) : super(
    formType: FormFieldType.switcher,
  );

  factory SwitcherFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}

final class CheckboxFieldConfiguration extends FormFieldConfiguration {

  const CheckboxFieldConfiguration({
    super.label,
  }) : super(
    formType: FormFieldType.switcher,
  );

  factory CheckboxFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}

final class DropdownFieldConfiguration extends FormFieldConfiguration {

  const DropdownFieldConfiguration({
    super.label,
  }) : super(
    formType: FormFieldType.switcher,
  );

  factory DropdownFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}