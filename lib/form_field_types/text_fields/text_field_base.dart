import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_configuration.dart';
import 'package:dynamic_forms/form_field_types/text_fields/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


export 'text_field.dart';
export 'password_field.dart';
export 'email_field.dart';
export 'cpf_cnpj_field.dart';
export 'phone_field.dart';


enum AvailableTextFieldInputTypes {
  text("text"),
  integer("integer"),
  decimal("decimal"),
  password("password"),
  cpf("cpf"),
  cnpj("cnpj"),
  email("email"),
  date("date"),
  phone("phone");

  final String key;
  const AvailableTextFieldInputTypes(this.key);

  static AvailableTextFieldInputTypes fromString(String value) {
    for (final AvailableTextFieldInputTypes e in AvailableTextFieldInputTypes.values) {
      if (e.key == value) return e;
    }
    throw UnimplementedError();
  }

}

base class BaseTextFormFieldConfiguration extends FormFieldConfiguration {

  static const INPUT_TYPE_KEY = "input_type";
  static const HINT_KEY = "hint";
  static const OBSCURE_KEY = "obscure";
  static const SUFFIX_KEY = "suffix";
  static const FORMATTER_KEY = "formatter";

  final AvailableTextFieldInputTypes type;

  /// If not defined, the label value will be used
  final String? hint;

  final IconData? suffixIcon; // how should i describe an suffixIcon as a json? Should i describe it at all?

  /// If true, tells the builder that it can be obscure or not.
  /// It does not describe the state of the obscure parameter, this should be handled inside a [FieldState]
  /// @see [PasswordState]
  final bool? isObscure;

  final TextInputFormatter? formatter;

  const BaseTextFormFieldConfiguration({
    required this.type,
    super.label,
    this.hint,
    super.flex,
    this.suffixIcon,
    required this.isObscure,
    this.formatter,
  }) : super(
    formType: FormFieldType.textField,
  );

  factory BaseTextFormFieldConfiguration.fromJSON(Map<String, dynamic> json) {

    var fieldType = AvailableTextFieldInputTypes.fromString(json[BaseTextFormFieldConfiguration.INPUT_TYPE_KEY]);

    switch (fieldType) {
      case AvailableTextFieldInputTypes.text: return TextFieldConfiguration.fromJSON(json);
      case AvailableTextFieldInputTypes.email: return EmailFieldConfiguration.fromJSON(json);
      case AvailableTextFieldInputTypes.password: return PasswordFieldConfiguration.fromJSON(json);
      case AvailableTextFieldInputTypes.cpf: return CpfFieldConfiguration.fromJSON(json);
      case AvailableTextFieldInputTypes.cnpj: return CnpjFieldConfiguration.fromJSON(json);
      case AvailableTextFieldInputTypes.phone: return PhoneFieldConfiguration.fromJSON(json);
      case AvailableTextFieldInputTypes.date: return DateTextFieldConfiguration.fromJSON(json);
      case AvailableTextFieldInputTypes.integer: return TextFieldConfiguration.fromJSON(json);
      case AvailableTextFieldInputTypes.decimal: return TextFieldConfiguration.fromJSON(json);
    }

  }

}


abstract base class BaseTextFieldState extends DynamicFormFieldState<String> {

  BaseTextFieldState({
    required super.key,
    super.initialValue,
    super.isRequired,
    required BaseTextFormFieldConfiguration configuration,
    bool hidden = false,
    super.enabled,
  }) : _hidden = hidden, super(configuration: configuration);


  // States that can change this parameter, must implement the setters
  bool _hidden;
  bool get hidden => _hidden;
  set hidden(bool isHidden) {
    _hidden = isHidden;
    notifyListeners();
  }


  @override
  BaseTextFormFieldConfiguration get configuration => super.configuration as BaseTextFormFieldConfiguration;


  factory BaseTextFieldState.fromJSON(Map<String, dynamic> json) {

    var fieldType = AvailableTextFieldInputTypes.fromString(json[BaseTextFormFieldConfiguration.INPUT_TYPE_KEY]);

    switch (fieldType) {
      case AvailableTextFieldInputTypes.text: return TextFieldState.fromJSON(json);
      case AvailableTextFieldInputTypes.integer: return TextFieldState.fromJSON(json);
      case AvailableTextFieldInputTypes.decimal: return TextFieldState.fromJSON(json);
      case AvailableTextFieldInputTypes.email: return EmailFieldState.fromJSON(json);
      case AvailableTextFieldInputTypes.password: return PasswordFieldState.fromJSON(json);
      case AvailableTextFieldInputTypes.cpf: return CpfFieldState.fromJSON(json);
      case AvailableTextFieldInputTypes.cnpj: return CnpjFieldState.fromJSON(json);
      case AvailableTextFieldInputTypes.phone: return PhoneFieldState.fromJSON(json);
      case AvailableTextFieldInputTypes.date: return DateTextFieldState.fromJSON(json);
    }

  }


}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////



class DefaultTextFieldBuilder extends StatefulWidget {


  const DefaultTextFieldBuilder({
    super.key,
    required this.state,
  });

  final BaseTextFieldState state;

  @override
  State<DefaultTextFieldBuilder> createState() => _DefaultTextFieldBuilderState();
}

class _DefaultTextFieldBuilderState extends State<DefaultTextFieldBuilder> {

  late final TextEditingController _editingController;


  @override
  void initState() {
    _editingController = TextEditingController(text: widget.state.value);

    widget.state.listenItself((stateValue) {
      if (stateValue != _editingController.text) {
        _editingController.text = stateValue ?? "";
      }
    });

    super.initState();
  }


  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: TextField(
        controller: _editingController,
        onChanged: (v) => widget.state.value = v,
        obscureText: widget.state.hidden,
        inputFormatters: widget.state.configuration.formatter != null ? [widget.state.configuration.formatter!] : null,
        enabled: widget.state.enabled,
        decoration: InputDecoration(
            labelText: widget.state.configuration.label ?? widget.state.key,
            errorText: widget.state.error,
            hintText: widget.state.configuration.hint,
            suffixIcon: Icon(widget.state.configuration.suffixIcon),
        ),
      ),
    );
  }
}


