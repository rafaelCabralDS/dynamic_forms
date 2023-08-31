import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_configuration.dart';
import 'package:flutter/material.dart' hide FormFieldState;

typedef FormFieldBuilder<T> = Widget Function(FormFieldState<T> field);
typedef TextFormFieldBuilder = Widget Function(TextFieldState field);

class BuildFormField<S extends FormFieldState> extends StatelessWidget {

  const BuildFormField(this.state, {super.key,
    this.textFieldBuilder = BuildFormField.buildTextFormField,
  });

  final S state;

  final TextFormFieldBuilder? textFieldBuilder;

  static Widget buildTextFormField(TextFieldState state) => _DefaultTextFormFieldBuilder(state: state);

  @override
  Widget build(BuildContext context) {
    switch (state.configuration.formType) {
      case FormFieldType.textField: return textFieldBuilder!.call(state as TextFieldState);
      case FormFieldType.switcher: throw UnimplementedError();
      case FormFieldType.checkbox: throw UnimplementedError();
      case FormFieldType.dropdownMenu: throw UnimplementedError();
    }
  }
}



class _DefaultTextFormFieldBuilder extends StatelessWidget {

  const _DefaultTextFormFieldBuilder({
    super.key,
    required this.state,
  });

  final TextFieldState state;

  @override
  Widget build(BuildContext context) {
    return TextField(
        onChanged: (v) => state.value = v,
        enabled: state.enabled,
        obscureText: state.configuration.obscure,
    );
  }
}
