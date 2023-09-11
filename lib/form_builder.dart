import 'package:dynamic_forms/form_controller.dart';
import 'package:dynamic_forms/form_field_types/text_fields/date_field.dart';
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
typedef DateTextFormFieldBuilder = Widget Function(DateTextFieldState field);

typedef CheckboxFormFieldBuilder = Widget Function(CheckboxFieldState field);
typedef DropdownFormFieldBuilder<T extends Object> = Widget Function(DropdownFieldState<T> field);
typedef SwitcherFormFieldBuilder = Widget Function(SwitcherFieldState field);

class DynamicForm extends StatefulWidget {

  final FormController controller;

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
  final DateTextFormFieldBuilder? dateTextFormFieldBuilder;
  final SwitcherFormFieldBuilder? switcherFormFieldBuilder;

  /// A map that overrides the default fields builders for specific field
  /// by the key value
  final Map<String, FormFieldBuilder>? customFieldsBuilder;

  final double runningSpacing;
  final double verticalSpacing;

  /// How the title and subtitle will be built
  final FormHeaderBuilder? formHeader;
  final FormHeaderBuilder? subformHeader;

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
    this.dateTextFormFieldBuilder,
    this.subformHeader,
    this.switcherFormFieldBuilder,
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

  Widget _buildDateField(DateTextFieldState state) {
    return widget.dateTextFormFieldBuilder?.call(state) ?? _buildDefaultTextField(state);
  }



  Widget _buildRow(List<DynamicFormFieldState> fields) => SeparatedRow(
    data: fields,
    separatorBuilder: (_,i) => SizedBox(width: widget.runningSpacing),
    itemBuilder: (_,i) => Builder(
        builder: (context) {

        var state = fields[i];
        var field = AnimatedBuilder(
            animation: state,
            builder: (context, child) {

              if (widget.customFieldsBuilder?.containsKey(state.key) ?? false) {
                return widget.customFieldsBuilder![state.key]!(state);
              }

              switch (state.configuration.formType) {
                case FormFieldType.textField:

                  switch ((state as BaseTextFieldState).configuration.type) {
                    case AvailableTextFieldInputTypes.text: return _buildTextField(state as TextFieldState);
                    case AvailableTextFieldInputTypes.integer: return _buildTextField(state as TextFieldState);
                    case AvailableTextFieldInputTypes.decimal: return _buildTextField(state as TextFieldState);
                    case AvailableTextFieldInputTypes.password: return _buildPasswordField(state as PasswordFieldState);
                    case AvailableTextFieldInputTypes.phone: return _buildPhoneField(state as PhoneFieldState);
                    case AvailableTextFieldInputTypes.email: return _buildEmailField(state as EmailFieldState);
                    case AvailableTextFieldInputTypes.cnpj: return _buildCnpjField(state as CnpjFieldState);
                    case AvailableTextFieldInputTypes.cpf: return _buildCpfField(state as CpfFieldState);
                    case AvailableTextFieldInputTypes.date: return _buildDateField(state as DateTextFieldState);
                  }

                case FormFieldType.switcher:
                  return widget.switcherFormFieldBuilder?.call(state as SwitcherFieldState) ?? DefaultSwitcherFieldBuilder(state: state as SwitcherFieldState);
                case FormFieldType.checkbox:
                  return widget.checkboxFieldBuilder?.call(state as CheckboxFieldState) ?? DefaultCheckboxFieldBuilder(state: state as CheckboxFieldState);
                case FormFieldType.dropdownMenu:
                  return Builder(
                      //key: UniqueKey(),
                      builder: (context) {
                        return widget.dropdownFieldBuilder?.call(state as DropdownFieldState) ?? DefaultDropdownFieldBuilder(state: state as DropdownFieldState);
                      }
                  );
              }
            }
        );

        if (state.configuration.flex != null) {
          return Expanded(
              flex: state.configuration.flex!,
              child: field
          );
        }else{
          return Flexible(child: field);
        }


      }
    ),
  );

  /// Build for every [FormModel] subform in the parent [FormModel] form controller
  Widget _buildSubform(FormModel subform) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: widget.verticalSpacing),

        widget.subformHeader?.call(subform) ?? _DefaultSubFormHeaderBuilder(subform: subform),

        //SizedBox(height: widget.verticalSpacing),

        SeparatedColumn(
          data: subform.fieldsMatrix,
          itemBuilder: (_,i) => _buildRow(subform.fieldsMatrix[i]),
          separatorBuilder: (_,i) => SizedBox(height: widget.verticalSpacing),
        ),

        SeparatedColumn(
          data: subform.subforms ?? [],
          itemBuilder: (_,i) => _buildSubform(subform.subforms![i]),
          separatorBuilder: (_,i) => SizedBox(height: widget.verticalSpacing),
        ),

      ],
    );

  }

  /// Build only once per controller
  Widget _buildForm(FormModel form) {

    return Column(
      children: [

        if (form.title != null || form.desc != null)
          widget.formHeader?.call(form) ?? _DefaultFormHeaderBuilder(form: form),

        SeparatedColumn(
          data: form.fieldsMatrix,
          itemBuilder: (_,i) => _buildRow(form.fieldsMatrix[i]),
          separatorBuilder: (_,i) => SizedBox(height: widget.verticalSpacing),
        ),

        SeparatedColumn(
          data: form.subforms ?? [],
          itemBuilder: (_,i) => _buildSubform(form.subforms![i]),
          separatorBuilder: (_,i) => SizedBox(height: widget.verticalSpacing),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {


    if (widget.controller is MultipleFormController) {

      return AnimatedBuilder(
        animation: widget.controller as MultipleFormController,
        builder: (context, child) {
          var forms = (widget.controller as MultipleFormController).forms;
          return SeparatedColumn(
            data: forms,
            itemBuilder: (_,i) => _buildForm(forms[i]),
            separatorBuilder: (_,i) => SizedBox(height: widget.verticalSpacing),
          );
        }
      );
    } else {
      return _buildForm((widget.controller as SingleFormController).form);
    }

  }
}


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

        const Divider(
          height: 30.0,
        )
      ],
    );
  }
}

class _DefaultSubFormHeaderBuilder extends StatelessWidget {

  final FormModel subform;
  const _DefaultSubFormHeaderBuilder({super.key, required this.subform});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (subform.title != null)
          Text(subform.title!, style: Theme.of(context).textTheme.headlineSmall),

        if (subform.desc != null)
          Text(subform.desc!, style: Theme.of(context).textTheme.labelSmall),


      ],
    );
  }
}

