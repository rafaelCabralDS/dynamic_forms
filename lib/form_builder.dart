import 'package:dynamic_forms/form_controller.dart';
import 'package:dynamic_forms/utils.dart';
import 'package:flutter/material.dart' hide FormFieldBuilder, FormFieldState;
import 'field_state.dart';
import 'form_field_configuration.dart';


typedef FormFieldBuilder<T> = Widget Function(DynamicFormFieldState<T> field);
typedef FormHeaderBuilder = Widget Function(FormModel form);

typedef DefaultTextFormFieldBuilder = Widget Function(BaseTextFieldState field);
typedef TextFormFieldBuilder = Widget Function(TextFieldState field);
typedef PasswordFormFieldBuilder = Widget Function(PasswordFieldState field);
typedef CpfFormFieldBuilder = Widget Function(CpfFieldState field);
typedef CnpjFormFieldBuilder = Widget Function(CnpjFieldState field);
typedef PhoneFormFieldBuilder = Widget Function(PhoneFieldState field);
typedef EmailFormFieldBuilder = Widget Function(EmailFieldState field);

typedef CheckboxFormFieldBuilder = Widget Function(CheckboxFieldState field);
typedef DropdownFormFieldBuilder<T extends Object> = Widget Function(DropdownFieldState<T> field);

class DynamicForm extends StatefulWidget {

  final DynamicFormController controller;

  /// If defined, all non defined specific field builder will fallback
  /// on this builder. Otherwise, they fall into [DefaultTextFieldBuilder]
  final DefaultTextFormFieldBuilder? defaultTextFormFieldBuilder;
  final TextFormFieldBuilder? textFieldBuilder;
  final PasswordFormFieldBuilder? passwordFieldBuilder;
  final EmailFormFieldBuilder? emailFieldBuilder;
  final PhoneFormFieldBuilder? phoneFieldBuilder;
  final CpfFormFieldBuilder? cpfFieldBuilder;
  final CnpjFormFieldBuilder? cnpjFieldBuilder;
  final CheckboxFormFieldBuilder? checkboxFieldBuilder;
  final DropdownFormFieldBuilder? dropdownFieldBuilder;

  /// A map that overrides the default fields builders for specific field
  /// by the key value
  final Map<String, FormFieldBuilder>? customFieldsBuilder;

  final double runningSpacing;
  final double verticalSpacing;

  /// How the title and subtitle will be built
  final FormHeaderBuilder? formHeader;

  const DynamicForm({super.key,
    required this.controller,
    this.defaultTextFormFieldBuilder,
    this.textFieldBuilder,
    this.passwordFieldBuilder,
    this.cnpjFieldBuilder,
    this.cpfFieldBuilder,
    this.emailFieldBuilder,
    this.phoneFieldBuilder,
    this.runningSpacing = 10.0,
    this.verticalSpacing = 10.0,
    this.formHeader,
    this.customFieldsBuilder,
    this.checkboxFieldBuilder,
    this.dropdownFieldBuilder,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();

}

class _DynamicFormState extends State<DynamicForm> {

  Widget _buildDefaultTextField(BaseTextFieldState state) {
    return widget.defaultTextFormFieldBuilder?.call(state) ?? DefaultTextFieldBuilder(state: state);
  }

  Widget _buildTextField(TextFieldState state) {
    return widget.textFieldBuilder?.call(state) ?? _buildDefaultTextField(state);
  }

  Widget _buildPasswordField(PasswordFieldState state) {
    return widget.passwordFieldBuilder?.call(state) ?? PasswordDefaultTextFieldBuilder(state: state);
  }

  Widget _buildCpfField(CpfFieldState state) {
    return widget.cpfFieldBuilder?.call(state) ?? _buildDefaultTextField(state);
  }

  Widget _buildCnpjField(CnpjFieldState state) {
    return widget.cnpjFieldBuilder?.call(state) ?? _buildDefaultTextField(state);
  }

  Widget _buildPhoneField(PhoneFieldState state) {
    return widget.phoneFieldBuilder?.call(state) ?? _buildDefaultTextField(state);
  }

  Widget _buildEmailField(EmailFieldState state) {
    return widget.emailFieldBuilder?.call(state) ?? _buildDefaultTextField(state);
  }


  Widget _buildRow(List<DynamicFormFieldState> fields) => SeparatedRow(
    data: fields,
    itemBuilder: (_,i) => Builder(
      builder: (context) {

        var state = fields[i];
        return Expanded(
          flex: state.configuration.flex,
          child: AnimatedBuilder(
            animation: state,
            builder: (context, child) {

              if (widget.customFieldsBuilder?.containsKey(state.key) ?? false) {
                return widget.customFieldsBuilder![state.key]!(state);
              }

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
                case FormFieldType.checkbox:
                  return widget.checkboxFieldBuilder?.call(state as CheckboxFieldState) ?? DefaultCheckboxFieldBuilder(state: state as CheckboxFieldState);
                case FormFieldType.dropdownMenu:
                  return widget.dropdownFieldBuilder?.call(state as DropdownFieldState) ?? DefaultDropdownFieldBuilder(state: state as DropdownFieldState);
              }
            }
          ),
        );
      }
    ),
    separatorBuilder: (_,i) => SizedBox(width: widget.runningSpacing),
  );


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        
          widget.formHeader?.call(widget.controller.form) ?? defaultFormHeaderBuilder(widget.controller.form),

        SeparatedColumn(
          data: widget.controller.fields,
          itemBuilder: (_,i) => _buildRow(widget.controller.fields[i]),
          separatorBuilder: (_,i) => SizedBox(height: widget.verticalSpacing),
        ),
      ],
    );
  }
}

Widget defaultFormHeaderBuilder(FormModel model) => _DefaultFormHeaderBuilder(form: model);

class _DefaultFormHeaderBuilder extends StatelessWidget {

  final FormModel form;
  const _DefaultFormHeaderBuilder({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (form.title != null)
          Text(form.title!, style: Theme.of(context).textTheme.headlineMedium),

        if (form.desc != null)
          Text(form.desc!, style: Theme.of(context).textTheme.labelMedium),

        Divider(
          height: 30.0,
        )
      ],
    );
  }
}

