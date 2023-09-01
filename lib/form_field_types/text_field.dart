import 'package:dynamic_forms/form_field_types/text_field_base.dart';
import 'package:flutter/services.dart';


import '../field_state.dart';

final class TextFieldConfiguration extends BaseTextFormFieldConfiguration {

 const TextFieldConfiguration({
    super.label,
    super.flex,
    super.hint,
    String? regexFormatterPattern,
    super.suffixIcon
}) : super(
    inputType: TextInputType.text,
    type: AvailableTextFieldInputTypes.text,
    isObscure: false,
    formatter: null,
  );

  static const factory = TextFieldConfiguration();

  factory TextFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return TextFieldConfiguration(
      label: json["label"],
      flex: json["flex"],
      hint: json["hint"],
      regexFormatterPattern: json["formatter"],
      suffixIcon: json["icon"]
    );
  }

}

final class TextFieldState extends BaseTextFieldState {


  TextFieldState({
    required super.key,
    super.initialValue,
    super.configuration = TextFieldConfiguration.factory,
    super.isRequired,
  }) : super();

   factory TextFieldState.fromJSON(Map<String, dynamic> json) => TextFieldState(
       key: json[DynamicFormFieldState.KEY_KEY],
       initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
       isRequired: json[DynamicFormFieldState.KEY_REQUIRED] ?? true,
       configuration: TextFieldConfiguration.fromJSON(json)
   );

  /// A normal text field is always valid
  @override
  bool isValid() {
    return true;
  }

}
