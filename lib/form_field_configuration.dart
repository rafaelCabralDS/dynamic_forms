
import 'package:dynamic_forms/form_field_types/text_field_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FormFieldType {
  textField("text_field"),
  switcher("switcher"),
  checkbox("checkbox"),
  dropdownMenu("dropdown");

  final String key;
  const FormFieldType(this.key);

  static FormFieldType fromString(String value) {
    for (final FormFieldType e in FormFieldType.values) {
      if (e.key == value) return e;
    }
    throw UnimplementedError();
  }
}

/// Describe properties about a form field
base class FormFieldConfiguration {

  static const String KEY_FIELD_TYPE = "field_type";
  static const String KEY_LABEL_TYPE = "label";
  static const String KEY_FLEX_TYPE = "flex";

  final FormFieldType formType;

  /// If not defined, the field [key] value will be used
  final String? label;

  /// If the field is in a row, it is possible to change the width of each
  /// by defining an flex value of the expanded element in the row.
  /// Default is all fields take the same space
  final int flex;


  const FormFieldConfiguration( {
    required this.formType,
    this.label,
    int? flex,
  }) : flex = flex ?? 1;

  factory FormFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    var fieldType = FormFieldType.fromString(json[FormFieldConfiguration.KEY_FIELD_TYPE]);

    switch (fieldType) {
      case FormFieldType.textField: return BaseTextFormFieldConfiguration.fromJSON(json);
      case FormFieldType.checkbox:  return CheckboxFieldConfiguration.fromJSON(json);
      case FormFieldType.switcher: return SwitcherFieldConfiguration.fromJSON(json);
      case FormFieldType.dropdownMenu: return DropdownFieldConfiguration.fromJSON(json);
    }
  }

}



/*
final class TextFormFieldConfiguration extends FormFieldConfiguration {

  static const INPUT_TYPE_KEY = "input_type";
  static const HINT_KEY = "hint";
  static const OBSCURE_KEY = "obscure";
  static const SUFFIX_KEY = "suffix";


  /// If not defined, the label value will be used
  final String? hint;

  /// The input data type (Default is text)
  final TextInputType inputType;

  final IconData? suffixIcon;

  const TextFormFieldConfiguration({
    super.label,
    this.hint,
    TextFormInputType inputType = TextFormInputType.text,
    super.flex,
    this.suffixIcon,
  }) : inputType = inputType, super(
    formType: FormFieldType.textField,
  );

  static const TextFormFieldConfiguration factory = TextFormFieldConfiguration();

  factory TextFormFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}

 */

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
    formType: FormFieldType.checkbox,
  );

  factory CheckboxFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}

final class DropdownFieldConfiguration extends FormFieldConfiguration {

  const DropdownFieldConfiguration({
    super.label,
  }) : super(
    formType: FormFieldType.dropdownMenu,
  );

  factory DropdownFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}