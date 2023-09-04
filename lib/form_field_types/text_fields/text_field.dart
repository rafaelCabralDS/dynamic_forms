import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:dynamic_forms/field_state.dart';
import 'package:flutter/services.dart';

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
      label: json[FormFieldConfiguration.KEY_LABEL],
      flex: json[FormFieldConfiguration.KEY_FLEX],
      hint: json[BaseTextFormFieldConfiguration.HINT_KEY],
      regexFormatterPattern: json[BaseTextFormFieldConfiguration.FORMATTER_KEY],
      suffixIcon: json[BaseTextFormFieldConfiguration.SUFFIX_KEY]
    );
  }

}

final class TextFieldState extends BaseTextFieldState {

  TextFieldState({
    required super.key,
    super.initialValue,
    TextFieldConfiguration configuration = TextFieldConfiguration.factory,
    super.isRequired,
  }) : super(configuration: configuration);

   factory TextFieldState.fromJSON(Map<String, dynamic> json) => TextFieldState(
       key: json[DynamicFormFieldState.KEY_KEY],
       initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
       isRequired: json[DynamicFormFieldState.KEY_REQUIRED] ?? true,
       configuration: TextFieldConfiguration.fromJSON(json)
   );


  @override
  bool get isValid => value != null && value!.isNotEmpty;

  @override
  bool validate([String invalidMsg = "Campo inválido"]) {
    /*
    if (value == null && error == null) return false;
    if (value == null && error != null) error = null;
    if (isRequired && value == null) error ??= "Campo obrigatório";
    if (value != null) error = null;


     */

    return isValid;
  }


}
