import 'package:dynamic_forms/field_state.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final class CpfFieldConfiguration extends BaseTextFormFieldConfiguration {


   CpfFieldConfiguration({
    super.label = "CPF",
    super.flex,
    super.hint = "000.000.000-00",
    super.suffixIcon
  }) : super(
    type: AvailableTextFieldInputTypes.cpf,
    isObscure: false,
    formatter: MaskTextInputFormatter(
        mask: '###.###.###-##',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    )
  );

   @override
   MaskTextInputFormatter get formatter => super.formatter as MaskTextInputFormatter;

  static final factory = CpfFieldConfiguration();

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

  CnpjFieldConfiguration({
    super.label = "CNPJ",
    super.flex,
    super.hint = "00.000.000/0000-00",
    super.suffixIcon,
  }) : super(
    type: AvailableTextFieldInputTypes.cnpj,
    isObscure: false,
    formatter: MaskTextInputFormatter(
        mask: '##.###.###/####-##',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.eager
    )
  );

  @override
  MaskTextInputFormatter get formatter => super.formatter as MaskTextInputFormatter;

  static final factory = CnpjFieldConfiguration();

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
    CpfFieldConfiguration? configuration,
    super.isRequired,
    super.enabled,
  }) : super(configuration: configuration ?? CpfFieldConfiguration.factory);



  factory CpfFieldState.fromJSON(Map<String, dynamic> json) => CpfFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED],
      configuration: CpfFieldConfiguration.fromJSON(json)
  );


  @override
  CpfFieldConfiguration get configuration => super.configuration as CpfFieldConfiguration;


  @override
  bool validator(String? v) {
    if (v == null) return false;
    const cpfRegex = r'^\d{3}\.\d{3}\.\d{3}\-\d{2}$';
    return RegExp(cpfRegex).hasMatch(v);
  }

}


final class CnpjFieldState extends BaseTextFieldState {

  CnpjFieldState({
    required super.key,
    super.initialValue,
    CnpjFieldConfiguration? configuration,
    super.isRequired,
    super.enabled,
  }) : super(configuration: configuration ?? CnpjFieldConfiguration.factory);

  factory CnpjFieldState.fromJSON(Map<String, dynamic> json) => CnpjFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED],
      configuration: CnpjFieldConfiguration.fromJSON(json)
  );

  @override
  CnpjFieldConfiguration get configuration => super.configuration as CnpjFieldConfiguration;


  @override
  bool validator(String? v) {
    if (v == null) return false;
    const cnpjRegex = r'^\d{2}\.\d{3}\.\d{3}/\d{4}\-\d{2}$';
    return RegExp(cnpjRegex).hasMatch(v);
  }

}



