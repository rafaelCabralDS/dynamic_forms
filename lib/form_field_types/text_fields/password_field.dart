import 'package:dynamic_forms/field_state.dart';
import 'package:flutter/material.dart';


final class PasswordFieldConfiguration extends BaseTextFormFieldConfiguration {
  const PasswordFieldConfiguration({
    super.label = "Senha",
    super.flex,
    super.hint,
  }) : super(
          type: AvailableTextFieldInputTypes.password,
          isObscure: true,
          formatter: null,
          suffixIcon: null, // is null because it will have an special form builder that can change between obscure or not
        );

  static const factory = PasswordFieldConfiguration();

  factory PasswordFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return PasswordFieldConfiguration(
        label: json["label"],
        flex: json["flex"],
        hint: json["hint"],
    );
  }

}

final class PasswordFieldState extends BaseTextFieldState {

  static const String passwordCriteria = '''
      A senha deve atender aos seguintes critérios:
      1. Deve ter pelo menos 6 caracteres de comprimento.
      2. Deve conter pelo menos uma letra (maiúscula ou minúscula).
      3. Deve conter pelo menos um número.
      4. Deve conter pelo menos um caractere especial (como &%#@!).
      ''';

  PasswordFieldState({
    required super.key,
    super.enabled,
    PasswordFieldConfiguration configuration = PasswordFieldConfiguration.factory
  }) : super(
    isRequired: true,
    initialValue: null,
    hidden: true,
    configuration: configuration,
  );

  factory PasswordFieldState.fromJSON(Map<String, dynamic> json) => PasswordFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      configuration: PasswordFieldConfiguration.fromJSON(json)
  );


  @override
  bool get isValid {

    if (value == null || value!.isEmpty || value!.length < 6) {
      return false;
    }
    const Pattern pattern = r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$";
    if (!RegExp(pattern as String).hasMatch(value!)) {
      return false;
    }

    return true;
  }

  @override
  bool validate([String? invalidMsg = "Campo inválido"]) {
    if (value == null) return false;
    if (!isValid && error == null) {
      error = passwordCriteria;
    }
    if (isValid && error != null) {
      error = null;
    }

    return isValid;
  }

}

class PasswordDefaultTextFieldBuilder extends StatefulWidget {

  const PasswordDefaultTextFieldBuilder({
    super.key,
    required this.state,
  });

  final PasswordFieldState state;

  @override
  State<PasswordDefaultTextFieldBuilder> createState() => _PasswordDefaultTextFieldBuilderState();
}

class _PasswordDefaultTextFieldBuilderState extends State<PasswordDefaultTextFieldBuilder> {

  late final TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.state.value);
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
        //onChanged: (v) => widget.state.value = v,
        obscureText: widget.state.hidden,
        inputFormatters: widget.state.configuration.formatter != null ? [widget.state.configuration.formatter!] : null,
        //enabled: ,
        decoration: InputDecoration(
          labelText: widget.state.configuration.label ?? widget.state.key,
          errorText: widget.state.error,
          hintText: widget.state.configuration.hint,
          suffixIcon: IconButton(
            onPressed: () => widget.state.hidden = !widget.state.hidden,
            icon: Icon(widget.state.hidden ? Icons.visibility_rounded : Icons.visibility_off_rounded, size: 24.0),
          ),



        ),
      ),
    );
  }
}


