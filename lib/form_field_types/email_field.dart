import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_types/text_field_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final class EmailFieldConfiguration extends BaseTextFormFieldConfiguration {


  const EmailFieldConfiguration({
    super.label,
    super.flex,
    super.hint,
    super.suffixIcon = Icons.email_rounded
  }) : super(
    inputType: TextInputType.emailAddress,
    type: AvailableTextFieldInputTypes.email,
    isObscure: false,
  );

  static const factory = EmailFieldConfiguration();

  factory EmailFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return EmailFieldConfiguration(
        label: json["label"],
        flex: json["flex"],
        hint: json["hint"],
        suffixIcon: json["icon"]
    );
  }

}


final class EmailFieldState extends BaseTextFieldState {

  static const Pattern _pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  EmailFieldState({
    required super.key,
    super.initialValue,
    super.configuration = EmailFieldConfiguration.factory,
    super.isRequired,
  }) : super();

  factory EmailFieldState.fromJSON(Map<String, dynamic> json) => EmailFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED],
      configuration: EmailFieldConfiguration.fromJSON(json)
  );


  /// A normal text field is always valid
  @override
  bool isValid() {

    if (value == null) return false;
    if (!RegExp(_pattern as String).hasMatch(value!)) {
      error = 'Email inválido';
      return false;
    } else {
      error = null;
      return true;
    }

  }

}
