import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_types/cpf_cnpj_field.dart';
import 'package:dynamic_forms/form_field_types/email_field.dart';
import 'package:dynamic_forms/form_field_types/password_field.dart';
import 'package:dynamic_forms/form_field_types/phone_field.dart';
import 'package:dynamic_forms/form_field_types/text_field_base.dart';
import 'package:flutter/material.dart' hide FormFieldState;

import 'form_field_types/text_field.dart';

typedef FormFieldBuilder<T> = Widget Function(DynamicFormFieldState<T> field);
typedef FormHeaderBuilder = Widget Function(FormModel form);

typedef DefaultTextFormFieldBuilder = Widget Function(BaseTextFieldState field);
typedef TextFormFieldBuilder = Widget Function(TextFieldState field);
typedef PasswordFormFieldBuilder = Widget Function(PasswordFieldState field);
typedef CpfFormFieldBuilder = Widget Function(CpfFieldState field);
typedef CnpjFormFieldBuilder = Widget Function(CnpjFieldState field);
typedef PhoneFormFieldBuilder = Widget Function(PhoneFieldState field);
typedef EmailFormFieldBuilder = Widget Function(EmailFieldState field);


class BuildFormField<S extends DynamicFormFieldState> extends StatelessWidget {

  const BuildFormField(this.state, {super.key,
    this.defaultTextFormFieldBuilder,
    this.textFieldBuilder,
    this.passwordFieldBuilder,
    this.cnpjFieldBuilder,
    this.cpfFieldBuilder,
    this.emailFieldBuilder,
    this.phoneFieldBuilder,
  });

  final S state;

  /// If defined, all non defined specific field builder will fallback
  /// on this builder. Otherwise, they fall into [DefaultTextFieldBuilder]
  final DefaultTextFormFieldBuilder? defaultTextFormFieldBuilder;
  final TextFormFieldBuilder? textFieldBuilder;
  final PasswordFormFieldBuilder? passwordFieldBuilder;
  final EmailFormFieldBuilder? emailFieldBuilder;
  final PhoneFormFieldBuilder? phoneFieldBuilder;
  final CpfFormFieldBuilder? cpfFieldBuilder;
  final CnpjFormFieldBuilder? cnpjFieldBuilder;


  Widget _buildDefaultField(BaseTextFieldState state) {
    return defaultTextFormFieldBuilder?.call(state) ?? DefaultTextFieldBuilder(state: state);
  }

  Widget _buildTextField(TextFieldState state) {
    return textFieldBuilder?.call(state) ?? _buildDefaultField(state);
  }

  Widget _buildPasswordField(PasswordFieldState state) {
    return passwordFieldBuilder?.call(state) ?? PasswordDefaultTextFieldBuilder(state: state);
  }

  Widget _buildCpfField(CpfFieldState state) {
    return cpfFieldBuilder?.call(state) ?? _buildDefaultField(state);
  }

  Widget _buildCnpjField(CnpjFieldState state) {
    return cnpjFieldBuilder?.call(state) ?? _buildDefaultField(state);
  }

  Widget _buildPhoneField(PhoneFieldState state) {
    return phoneFieldBuilder?.call(state) ?? _buildDefaultField(state);
  }

  Widget _buildEmailField(EmailFieldState state) {
    return emailFieldBuilder?.call(state) ?? _buildDefaultField(state);
  }


  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: state,
        builder: (_,__) {
          switch (state.configuration.formType) {
            case FormFieldType.textField:

              switch ((state as BaseTextFieldState).configuration.type) {
                case AvailableTextFieldInputTypes.text: return _buildTextField(state as TextFieldState);
                case AvailableTextFieldInputTypes.password: return _buildPasswordField(state as PasswordFieldState);
                case AvailableTextFieldInputTypes.phone: return _buildPhoneField(state as PhoneFieldState);
                case AvailableTextFieldInputTypes.email: return _buildEmailField(state as EmailFieldState);
                case AvailableTextFieldInputTypes.cnpj: return _buildCnpjField(state as CnpjFieldState);
                case AvailableTextFieldInputTypes.cpf: return _buildCpfField(state as CpfFieldState);
              }

            case FormFieldType.switcher: throw UnimplementedError();
            case FormFieldType.checkbox: throw UnimplementedError();
            case FormFieldType.dropdownMenu: throw UnimplementedError();
          }
        }
    );


  }
}


