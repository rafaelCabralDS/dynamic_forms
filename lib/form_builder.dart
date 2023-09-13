import 'package:dynamic_forms/form_controller.dart';
import 'package:dynamic_forms/form_field_types/expandable_field.dart';
import 'package:dynamic_forms/form_field_types/file_field.dart';
import 'package:dynamic_forms/form_model.dart';
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
typedef SwitcherFormFieldBuilder = Widget Function(SwitchFieldState field);
typedef FileFormFieldBuilder = Widget Function(FilePickerFieldState field);
typedef ExpandableFieldBuilder = Widget Function(ExpandableFieldState field);



final class FormFieldStyle {

  /// If defined, all non defined specific field builder will fallback
  /// on this builder. Otherwise, they fall into [DefaultTextFieldBuilder]
  final DefaultTextFormFieldBuilder baseTextFormFieldBuilder;
  final TextFormFieldBuilder textFieldBuilder;
  final PasswordFormFieldBuilder passwordFieldBuilder;
  final EmailFormFieldBuilder emailFieldBuilder;
  final PhoneFormFieldBuilder phoneFieldBuilder;
  final CpfFormFieldBuilder cpfFieldBuilder;
  final CnpjFormFieldBuilder cnpjFieldBuilder;
  final CheckboxFormFieldBuilder checkboxFieldBuilder;
  final DropdownFormFieldBuilder dropdownFieldBuilder;
  final DateTextFormFieldBuilder dateTextFormFieldBuilder;
  final SwitcherFormFieldBuilder switchFormFieldBuilder;
  final FileFormFieldBuilder fileFormFieldBuilder;

  /// A map that overrides the default fields builders for specific field
  /// by the key value
  final Map<String, FormFieldBuilder>? customFieldsBuilder;

  final double runningSpacing;
  final double verticalSpacing;

  final FormHeaderBuilder formHeaderBuilder;
  final FormHeaderBuilder subformHeaderBuilder;

  const FormFieldStyle({
    this.baseTextFormFieldBuilder = defaultTextFormFieldBuilder,
    TextFormFieldBuilder? textFieldBuilder,
    CpfFormFieldBuilder? cpfFieldBuilder,
    CnpjFormFieldBuilder? cnpjFieldBuilder,
    PhoneFormFieldBuilder? phoneFieldBuilder,
    EmailFormFieldBuilder? emailFieldBuilder,
    DateTextFormFieldBuilder? dateTextFormFieldBuilder,
    this.passwordFieldBuilder = defaultPasswordFormFieldBuilder,
    this.checkboxFieldBuilder = defaultCheckboxFormFieldBuilder,
    this.dropdownFieldBuilder = defaultDropdownFormFieldBuilder,
    this.switchFormFieldBuilder = defaultSwitchFormFieldBuilder,
    this.fileFormFieldBuilder = defaultFilePickerFormFieldBuilder,
    this.runningSpacing = 10.0,
    this.verticalSpacing = 10.0,
    this.customFieldsBuilder,
    this.formHeaderBuilder = defaultFormHeaderBuilder,
    this.subformHeaderBuilder = defaultSubformHeaderBuilder,
  })  :
        textFieldBuilder = textFieldBuilder ?? baseTextFormFieldBuilder,
        cpfFieldBuilder = cpfFieldBuilder ?? baseTextFormFieldBuilder,
        cnpjFieldBuilder = cnpjFieldBuilder ?? baseTextFormFieldBuilder,
        emailFieldBuilder = emailFieldBuilder ?? baseTextFormFieldBuilder,
        phoneFieldBuilder = phoneFieldBuilder ?? baseTextFormFieldBuilder,
        dateTextFormFieldBuilder = dateTextFormFieldBuilder ?? baseTextFormFieldBuilder;


  static Widget defaultTextFormFieldBuilder(BaseTextFieldState state) => DefaultTextFieldBuilder(state: state);
  static Widget defaultPasswordFormFieldBuilder(PasswordFieldState state) => DefaultPasswordTextFieldBuilder(state: state);
  static Widget defaultCheckboxFormFieldBuilder(CheckboxFieldState state) => DefaultCheckboxFieldBuilder(state: state);
  static Widget defaultSwitchFormFieldBuilder(SwitchFieldState state) => DefaultSwitchFieldBuilder(state: state);
  static Widget defaultDropdownFormFieldBuilder<T extends Object>(DropdownFieldState<T> state) => DefaultDropdownFieldBuilder(state: state);
  static Widget defaultFilePickerFormFieldBuilder(FilePickerFieldState state) => DefaultFilePickerBuilder(state: state);
  static Widget defaultFormHeaderBuilder(FormModel form) => _DefaultFormHeaderBuilder(form: form);
  static Widget defaultSubformHeaderBuilder(FormModel subform) => _DefaultSubFormHeaderBuilder(subform: subform);

}

class FieldBuilder extends StatelessWidget {

  final DynamicFormFieldState state;
  final FormFieldStyle style;

  const FieldBuilder({super.key,
    required this.state,
    this.style = const FormFieldStyle()});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: state,
        builder: (context, child) {

          if (style.customFieldsBuilder?.containsKey(state.key) ?? false) {
            return style.customFieldsBuilder![state.key]!(state);
          }

          switch (state.configuration.formType) {
            case FormFieldType.textField:

              switch ((state as BaseTextFieldState).configuration.type) {
                case AvailableTextFieldInputTypes.text: return style.textFieldBuilder(state as TextFieldState);
                case AvailableTextFieldInputTypes.integer: return style.textFieldBuilder(state as TextFieldState);
                case AvailableTextFieldInputTypes.decimal: return style.textFieldBuilder(state as TextFieldState);
                case AvailableTextFieldInputTypes.password: return style.passwordFieldBuilder(state as PasswordFieldState);
                case AvailableTextFieldInputTypes.phone: return style.phoneFieldBuilder(state as PhoneFieldState);
                case AvailableTextFieldInputTypes.email: return style.emailFieldBuilder(state as EmailFieldState);
                case AvailableTextFieldInputTypes.cnpj: return style.cnpjFieldBuilder(state as CnpjFieldState);
                case AvailableTextFieldInputTypes.cpf: return style.cpfFieldBuilder(state as CpfFieldState);
                case AvailableTextFieldInputTypes.date: return style.dateTextFormFieldBuilder(state as DateTextFieldState);
              }

            case FormFieldType.switcher:
              return style.switchFormFieldBuilder.call(state as SwitchFieldState);
            case FormFieldType.checkbox:
              return style.checkboxFieldBuilder.call(state as CheckboxFieldState);
            case FormFieldType.dropdownMenu:
              return style.dropdownFieldBuilder.call(state as DropdownFieldState);
            case FormFieldType.file:
              return style.fileFormFieldBuilder.call(state as FilePickerFieldState);
            case FormFieldType.expandable:
              return BuildExpandableFormField(state: state as ExpandableBaseFieldState, style: style);
          }
        }
    );
  }
}

class DynamicForm extends StatelessWidget {

  const DynamicForm({super.key,
    required this.controller,
    this.style = const FormFieldStyle()
  });

  final FormController controller;
  final FormFieldStyle style;

  @override
  Widget build(BuildContext context) {

    if (controller is MultipleFormController) {

      return AnimatedBuilder(
          animation: controller as MultipleFormController,
          builder: (context, child) {
            var forms = (controller as MultipleFormController).forms;
            return SeparatedColumn(
              data: forms,
              itemBuilder: (_,i) => FormBuilder(form: forms[i], style: style),
              separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
            );
          }
      );
    } else {
      return FormBuilder(form: (controller as SingleFormController).form, style: style);
    }
  }
}

class FormBuilder extends StatelessWidget {

  final FormModel form;
  final FormFieldStyle style;

  const FormBuilder({
    super.key,
    required this.form,
    this.style = const FormFieldStyle(),
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        if (form.title != null || form.desc != null)
         style.formHeaderBuilder(form),

        FormFieldsBuilder(fields: form.fieldsMatrix, style: style),

        SeparatedColumn(
          data: form.subforms ?? [],
          itemBuilder: (_,i) => SubformBuilder(subform: form.subforms![i], style: style),
          separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
        ),

      ],
    );
  }
}

class SubformBuilder extends StatelessWidget {

  final FormModel subform;
  final FormFieldStyle style;

  const SubformBuilder({super.key,
    required this.subform,
    this.style = const FormFieldStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: style.verticalSpacing),

        if ((subform.title != null && subform.title!.isNotEmpty) || (subform.desc != null && subform.desc!.isNotEmpty))
          style.subformHeaderBuilder(subform),

        FormFieldsBuilder(fields: subform.fieldsMatrix, style: style),

        SeparatedColumn(
          data: subform.subforms ?? [],
          itemBuilder: (_,i) => SubformBuilder(subform: subform.subforms![i], style: style),
          separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
        ),

      ],
    );
  }
}

class FormFieldsBuilder extends StatelessWidget {

  final List<List<DynamicFormFieldState>> fields;
  final FormFieldStyle style;

  const FormFieldsBuilder({
    super.key,
    required this.fields,
    this.style = const FormFieldStyle(),
  });

  @override
  Widget build(BuildContext context) {

    return SeparatedColumn(
      data: fields,
      itemBuilder: (_,columnIndex) {
        var row = fields[columnIndex];
        return SeparatedRow(
          data: row,
          separatorBuilder: (_,i) => SizedBox(width: style.runningSpacing),
          itemBuilder: (_,rowIndex) {
            var state = row[rowIndex];
            if (state.configuration.flex != null) {
              return Expanded(
                  flex: state.configuration.flex!,
                  child: FieldBuilder(state: state, style: style)
              );
            }else{
              return Flexible(child: FieldBuilder(state: state, style: style));
            }
          },
        );
      },
      separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
    );

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

