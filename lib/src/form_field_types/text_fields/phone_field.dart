import 'package:dynamic_forms/src/field_state.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:dynamic_forms/src/form_field_types/text_fields/text_field_base.dart';

final class PhoneFieldConfiguration extends BaseTextFormFieldConfiguration {

  PhoneFieldConfiguration({
    super.label = "Telefone",
    super.flex,
    super.hint = "(00) 00000 - 0000",
    super.suffixIcon = Icons.phone_rounded
  }) : super(
    type: AvailableTextFieldInputTypes.phone,
    isObscure: false,
    formatter: MaskTextInputFormatter(
        mask: '(##) ##### - ####',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    )
  );

  @override
  MaskTextInputFormatter get formatter => super.formatter as MaskTextInputFormatter;

  static final factory = PhoneFieldConfiguration();

  factory PhoneFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return PhoneFieldConfiguration(
        label: json["label"],
        flex: json["flex"],
        hint: json["hint"],
        suffixIcon: json["icon"]
    );
  }

}

final class PhoneFieldState extends BaseTextFieldState {

  PhoneFieldState({
    required super.key,
    super.initialValue,
    PhoneFieldConfiguration? configuration,
    super.isRequired,
    super.enabled,
  }) : super(configuration: configuration ?? PhoneFieldConfiguration.factory);

  factory PhoneFieldState.fromJSON(Map<String, dynamic> json) => PhoneFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED],
      configuration: PhoneFieldConfiguration.fromJSON(json)
  );

  @override
  PhoneFieldConfiguration get configuration => super.configuration as PhoneFieldConfiguration;

  @override
  bool validator(String? v) {
    if (v == null) return false;
    const phoneRegex = r'^\(\d{2}\)\s?\d{5}\s?\-\s?\d{4}$';
    return RegExp(phoneRegex).hasMatch(v);
  }


}



