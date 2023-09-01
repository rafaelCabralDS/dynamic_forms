import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_types/email_field.dart';
import 'package:dynamic_forms/form_field_types/text_field_base.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final class PhoneFieldConfiguration extends BaseTextFormFieldConfiguration {

  @override
  MaskTextInputFormatter get formatter => MaskTextInputFormatter(
      mask: '(##) ##### - ####',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  const PhoneFieldConfiguration({
    super.label = "Telefone",
    super.flex,
    super.hint = "(00) 00000 - 0000",
    super.suffixIcon = Icons.phone_rounded
  }) : super(
    inputType: TextInputType.number,
    type: AvailableTextFieldInputTypes.phone,
    isObscure: false,
  );

  static const factory = PhoneFieldConfiguration();

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
    super.configuration = PhoneFieldConfiguration.factory,
    super.isRequired,
  }) : super();

  factory PhoneFieldState.fromJSON(Map<String, dynamic> json) => PhoneFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED],
      configuration: EmailFieldConfiguration.fromJSON(json)
  );


  /// A normal text field is always valid
  @override
  bool isValid() {
    return (configuration as PhoneFieldConfiguration).formatter.getUnmaskedText().length == 11;
  }

}



