import 'package:dynamic_forms/src/components/dynamic_form_theme.dart';
import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/form_controller.dart';
import 'package:dynamic_forms/src/form_field_configuration.dart';
import 'package:dynamic_forms/src/form_field_types/autocompleter_field.dart';
import 'package:dynamic_forms/src/utils.dart';
import 'package:flutter/material.dart' ;


/// Builds all forms and subforms given by the [controller] parameter, following the
/// [DynamicFormTheme]
class DynamicForm extends StatelessWidget {

  const DynamicForm({super.key,
    required this.controller,
    this.style,
  });

  final FormController controller;
  final DynamicFormThemeData? style;

  @override
  Widget build(BuildContext context) {

    var theme = DynamicFormTheme.of(context).merge(themeData: style);

    return DynamicFormTheme(
        data: theme,
        child: Builder(
          builder: (_) {
            if (controller is MultipleFormController) {

              return AnimatedBuilder(
                  animation: controller as MultipleFormController,
                  builder: (context, child) {
                    var forms = (controller as MultipleFormController).forms;
                    return SeparatedColumn(
                      data: forms,
                      itemBuilder: (_,i) => AnimatedBuilder(
                        animation: forms[i],
                        builder: (context, child) {
                          return FormBuilder(form: forms[i]);
                        }
                      ),
                      separatorBuilder: (_,i) => SizedBox(height: theme.verticalSpacing),
                    );
                  }
              );
            } else {
              return AnimatedBuilder(
                animation: (controller as SingleFormController).form,
                builder: (context, child) {
                  return FormBuilder(form: (controller as SingleFormController).form);
                }
              );
            }
          },
        )
    );


  }
}

typedef DynamicFormFieldBuilder<T extends DynamicFormFieldState> = Widget Function(T field);

/// This can build any [DynamicFormFieldState], deciding witch widget should be built
/// based on the [FormFieldType] parameter of the [FormFieldConfiguration] from the field state,
/// using the designed [DynamicFormTheme] found above.
class FieldBuilder extends StatelessWidget {

  final DynamicFormFieldState state;

  const FieldBuilder({super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {

    var style = DynamicFormTheme.of(context);

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
            case FormFieldType.autocomplete:
              return AutocompleteFieldBuilder(state: state as AutocompleteFieldState);
            case FormFieldType.switcher:
              return style.switchFormFieldBuilder.call(state as SwitchFieldState);
            case FormFieldType.checkbox:
              return style.checkboxFieldBuilder.call(state as CheckboxFieldState);
            case FormFieldType.dropdownMenu:
              return style.dropdownFieldBuilder.call(state as DropdownFieldState);
            case FormFieldType.file:
              return style.fileFormFieldBuilder.call(state as FilePickerFieldState);
            case FormFieldType.expandable:
              return style.expandableFieldBuilder.call(state as ExpandableBaseFieldState);
            case FormFieldType.table:
              return TableFieldBuilder(state: state as TableFieldState);
          }
        }
    );
  }
}

typedef FormHeaderBuilder = Widget Function(FormModel form);

class FormBuilder extends StatelessWidget {

  final FormModel form;

  const FormBuilder({
    super.key,
    required this.form,
  });


  @override
  Widget build(BuildContext context) {

    var style = DynamicFormTheme.of(context);

    return Column(
      children: [

        if (form.title != null || form.desc != null)
         style.formHeaderBuilder(form),

        FormFieldsBuilder(fields: form.fieldsMatrix, style: style),

        SeparatedColumn(
          data: form.subforms,
          itemBuilder: (_,i) => AnimatedBuilder(
            animation: form.subforms[i],
            builder: (context, child) {
              return SubformBuilder(subform: form.subforms[i]);
            }
          ),
          separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
        ),

      ],
    );
  }
}

class SubformBuilder extends StatelessWidget {

  final FormModel subform;

  const SubformBuilder({super.key,
    required this.subform,
  });

  @override
  Widget build(BuildContext context) {

    var style = DynamicFormTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: style.verticalSpacing),

        if ((subform.title != null && subform.title!.isNotEmpty) || (subform.desc != null && subform.desc!.isNotEmpty))
          style.subformHeaderBuilder(subform),

        FormFieldsBuilder(fields: subform.fieldsMatrix, style: style),

        SeparatedColumn(
          data: subform.subforms,
          itemBuilder: (_,i) => SubformBuilder(subform: subform.subforms[i]),
          separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
        ),

      ],
    );
  }
}

class FormFieldsBuilder extends StatelessWidget {

  final List<List<DynamicFormFieldState>> fields;
  final DynamicFormThemeData? style;

  const FormFieldsBuilder({
    super.key,
    required this.fields,
    this.style,
  });

  @override
  Widget build(BuildContext context) {

    var style = this.style ?? DynamicFormTheme.of(context);

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
                  child: FieldBuilder(state: state)
              );
            }else{
              return Flexible(child: FieldBuilder(state: state));
            }
          },
        );
      },
      separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
    );

  }
}

class DefaultFormHeaderBuilder extends StatelessWidget {

  final FormModel form;
  const DefaultFormHeaderBuilder({super.key, required this.form});

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

class DefaultSubFormHeaderBuilder extends StatelessWidget {

  final FormModel subform;
  const DefaultSubFormHeaderBuilder({super.key, required this.subform});

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

