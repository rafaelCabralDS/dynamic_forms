import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_types/text_field_base.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final class CpfFieldConfiguration extends BaseTextFormFieldConfiguration {

  @override
  MaskTextInputFormatter get formatter => MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  const CpfFieldConfiguration({
    super.label = "CPF",
    super.flex,
    super.hint = "000.000.000-00",
    super.suffixIcon
  }) : super(
    inputType: TextInputType.number,
    type: AvailableTextFieldInputTypes.cpf,
    isObscure: false,
  );

  static const factory = CpfFieldConfiguration();

  factory CpfFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return CpfFieldConfiguration(
        label: json["label"],
        flex: json["flex"],
        hint: json["hint"],
        suffixIcon: json["icon"]
    );
  }

}

final class CnpjFieldConfiguration extends BaseTextFormFieldConfiguration {


  @override
  MaskTextInputFormatter get formatter => MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.eager
  );

  const CnpjFieldConfiguration({
    super.label = "CNPJ",
    super.flex,
    super.hint = "00.000.000/0000-00",
    super.suffixIcon
  }) : super(
    inputType: TextInputType.number,
    type: AvailableTextFieldInputTypes.cnpj,
    isObscure: false,
    //formatter: formatter
  );

  static const factory = CnpjFieldConfiguration();

  factory CnpjFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return CnpjFieldConfiguration(
        label: json["label"],
        flex: json["flex"],
        hint: json["hint"],
        suffixIcon: json["icon"]
    );
  }
}


final class CpfFieldState extends BaseTextFieldState {

  CpfFieldState({
    required super.key,
    super.initialValue,
    super.configuration = CpfFieldConfiguration.factory,
    super.isRequired,
  }) : super();


  factory CpfFieldState.fromJSON(Map<String, dynamic> json) => CpfFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED],
      configuration: CpfFieldConfiguration.fromJSON(json)
  );


  /// A normal text field is always valid
  @override
  bool isValid() {
    return (configuration as CpfFieldConfiguration).formatter.getUnmaskedText().length == 11;
  }

}


final class CnpjFieldState extends BaseTextFieldState {

  CnpjFieldState({
    required super.key,
    super.initialValue,
    super.configuration = CnpjFieldConfiguration.factory,
    super.isRequired,
  }) : super();

  factory CnpjFieldState.fromJSON(Map<String, dynamic> json) => CnpjFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED],
      configuration: CnpjFieldConfiguration.fromJSON(json)
  );


  /// A normal text field is always valid
  @override
  bool isValid() {
    return ((configuration as CnpjFieldConfiguration).formatter).getUnmaskedText().length == 14;
  }

}



