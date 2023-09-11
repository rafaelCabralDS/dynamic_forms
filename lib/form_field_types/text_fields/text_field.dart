import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:dynamic_forms/field_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils.dart';


final class TextFieldConfiguration extends BaseTextFormFieldConfiguration {

 const TextFieldConfiguration({
    super.label,
    super.flex,
    super.hint,
    //String? regexFormatterPattern,
    super.suffixIcon,
    super.formatter,
}) : super(
    type: AvailableTextFieldInputTypes.text,
    isObscure: false,
  );

 factory TextFieldConfiguration.number({
   String? label,
   int? flex,
   String? hint,
   //String? regexFormatterPattern,
   IconData? suffixIcon,
 }) => TextFieldConfiguration(
   label: label,
   flex: flex,
   hint: hint,
   //regexFormatterPattern: regexFormatterPattern,
   suffixIcon: suffixIcon,
   formatter: FilteringTextInputFormatter.digitsOnly,
 );

 factory TextFieldConfiguration.decimal({
   String? label,
   int? flex,
   String? hint,
   String? regexFormatterPattern,
   IconData? suffixIcon,
 }) => TextFieldConfiguration(
   label: label,
   flex: flex,
   hint: hint,
   //regexFormatterPattern: regexFormatterPattern,
   suffixIcon: suffixIcon,
   formatter: const DecimalTextInputFormatter(decimalRange: 2),
 );

  static const factory = TextFieldConfiguration(formatter: null);

  factory TextFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return TextFieldConfiguration(
      label: json[FormFieldConfiguration.KEY_LABEL],
      flex: json[FormFieldConfiguration.KEY_FLEX],
      hint: json[BaseTextFormFieldConfiguration.HINT_KEY],
     // regexFormatterPattern: json[BaseTextFormFieldConfiguration.FORMATTER_KEY],
      suffixIcon: json[BaseTextFormFieldConfiguration.SUFFIX_KEY],
      formatter: (json[BaseTextFormFieldConfiguration.INPUT_TYPE_KEY] as String?).asFormatter,
    );
  }

}

final class TextFieldState extends BaseTextFieldState {

  TextFieldState({
    required super.key,
    super.initialValue,
    TextFieldConfiguration configuration = TextFieldConfiguration.factory,
    super.isRequired,
    super.enabled,
  }) : super(
      configuration: configuration
  );

  factory TextFieldState.number({
    required String key,
    String? initialValue,
    TextFieldConfiguration configuration = TextFieldConfiguration.factory,
    bool? isRequired,
    bool? enabled,
  }) => TextFieldState(
      key: key,
      initialValue: initialValue,
      isRequired: isRequired,
      enabled: enabled,
      configuration: TextFieldConfiguration.number(
        label: configuration.label,
        flex: configuration.flex,
        hint: configuration.hint,
        //regexFormatterPattern: configuration.,
        suffixIcon: configuration.suffixIcon,
      )
  );

  factory TextFieldState.decimal({
    required String key,
    String? initialValue,
    TextFieldConfiguration configuration = TextFieldConfiguration.factory,
    bool? isRequired,
    bool? enabled,
  }) => TextFieldState(
      key: key,
      enabled: enabled,
      initialValue: initialValue,
      isRequired: isRequired,
      configuration: TextFieldConfiguration.decimal(
        label: configuration.label,
        flex: configuration.flex,
        hint: configuration.hint,
        //regexFormatterPattern: configuration.,
        suffixIcon: configuration.suffixIcon,
      )
  );


   factory TextFieldState.fromJSON(Map<String, dynamic> json) => TextFieldState(
       key: json[DynamicFormFieldState.KEY_KEY],
       initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
       isRequired: json[DynamicFormFieldState.KEY_REQUIRED] ?? true,
       enabled: json[DynamicFormFieldState.KEY_ENABLED],
       configuration: TextFieldConfiguration.fromJSON(json),
   );


  @override
  bool validator(String? v) => v != null && v.isNotEmpty;

  @override
  bool validate([String invalidMsg = "Campo inválido"]) {
    return isValid;
  }


}
