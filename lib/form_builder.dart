import 'package:dynamic_forms/form_controller.dart';
import 'package:dynamic_forms/form_field_types/expandable_field.dart';
import 'package:dynamic_forms/form_field_types/file_field.dart';
import 'package:dynamic_forms/form_field_types/table_field/table_field_state.dart';
import 'package:dynamic_forms/form_model.dart';
import 'package:dynamic_forms/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide FormFieldBuilder, FormFieldState;
import 'field_state.dart';
import 'form_field_configuration.dart';
import 'form_field_types/table_field/table_components.dart';


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
typedef ExpandableFieldBuilder = Widget Function(ExpandableBaseFieldState field);


@immutable
class DynamicFormThemeData with Diagnosticable {

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
  final ExpandableFieldBuilder expandableFieldBuilder;
  final TableFieldStyle tableFieldStyle;

  /// A map that overrides the default fields builders for specific field
  /// by the key value
  final Map<String, FormFieldBuilder>? customFieldsBuilder;

  final double runningSpacing;
  final double verticalSpacing;

  final FormHeaderBuilder formHeaderBuilder;
  final FormHeaderBuilder subformHeaderBuilder;

  const DynamicFormThemeData({
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
    this.expandableFieldBuilder = defaultExpandableFieldBuilder,
    this.tableFieldStyle = const TableFieldStyle(),
  })  :
        textFieldBuilder = textFieldBuilder ?? baseTextFormFieldBuilder,
        cpfFieldBuilder = cpfFieldBuilder ?? baseTextFormFieldBuilder,
        cnpjFieldBuilder = cnpjFieldBuilder ?? baseTextFormFieldBuilder,
        emailFieldBuilder = emailFieldBuilder ?? baseTextFormFieldBuilder,
        phoneFieldBuilder = phoneFieldBuilder ?? baseTextFormFieldBuilder,
        dateTextFormFieldBuilder = dateTextFormFieldBuilder ?? baseTextFormFieldBuilder;

  DynamicFormThemeData copyWith({
    DefaultTextFormFieldBuilder? baseTextFormFieldBuilder,
    TextFormFieldBuilder? textFieldBuilder,
    PasswordFormFieldBuilder? passwordFieldBuilder,
    EmailFormFieldBuilder? emailFieldBuilder,
    PhoneFormFieldBuilder? phoneFieldBuilder,
    CpfFormFieldBuilder? cpfFieldBuilder,
    CnpjFormFieldBuilder? cnpjFieldBuilder,
    CheckboxFormFieldBuilder? checkboxFieldBuilder,
    DropdownFormFieldBuilder? dropdownFieldBuilder,
    DateTextFormFieldBuilder? dateTextFormFieldBuilder,
    SwitcherFormFieldBuilder? switchFormFieldBuilder,
    FileFormFieldBuilder? fileFormFieldBuilder,
    ExpandableFieldBuilder? expandableFieldBuilder,
    Map<String, FormFieldBuilder>? customFieldsBuilder,
    double? runningSpacing,
    double? verticalSpacing,
    FormHeaderBuilder? formHeaderBuilder,
    FormHeaderBuilder? subformHeaderBuilder,
    TableFieldStyle? tableFieldStyle,
  }) {
    return DynamicFormThemeData(
      baseTextFormFieldBuilder: baseTextFormFieldBuilder ?? this.baseTextFormFieldBuilder,
      textFieldBuilder: textFieldBuilder ?? this.textFieldBuilder,
      passwordFieldBuilder: passwordFieldBuilder ?? this.passwordFieldBuilder,
      emailFieldBuilder: emailFieldBuilder ?? this.emailFieldBuilder,
      phoneFieldBuilder: phoneFieldBuilder ?? this.phoneFieldBuilder,
      cpfFieldBuilder: cpfFieldBuilder ?? this.cpfFieldBuilder,
      cnpjFieldBuilder: cnpjFieldBuilder ?? this.cnpjFieldBuilder,
      checkboxFieldBuilder: checkboxFieldBuilder ?? this.checkboxFieldBuilder,
      dropdownFieldBuilder: dropdownFieldBuilder ?? this.dropdownFieldBuilder,
      dateTextFormFieldBuilder: dateTextFormFieldBuilder ?? this.dateTextFormFieldBuilder,
      switchFormFieldBuilder: switchFormFieldBuilder ?? this.switchFormFieldBuilder,
      fileFormFieldBuilder: fileFormFieldBuilder ?? this.fileFormFieldBuilder,
      expandableFieldBuilder: expandableFieldBuilder ?? this.expandableFieldBuilder,
      customFieldsBuilder: customFieldsBuilder ?? this.customFieldsBuilder,
      runningSpacing: runningSpacing ?? this.runningSpacing,
      verticalSpacing: verticalSpacing ?? this.verticalSpacing,
      formHeaderBuilder: formHeaderBuilder ?? this.formHeaderBuilder,
      subformHeaderBuilder: subformHeaderBuilder ?? this.subformHeaderBuilder,
      tableFieldStyle: tableFieldStyle ?? this.tableFieldStyle,
    );
  }

  DynamicFormThemeData lerp({
    DynamicFormThemeData? themeData,
  }) {
    return DynamicFormThemeData(
      baseTextFormFieldBuilder: themeData?.baseTextFormFieldBuilder ?? baseTextFormFieldBuilder,
      textFieldBuilder: themeData?.textFieldBuilder ?? textFieldBuilder,
      passwordFieldBuilder: themeData?.passwordFieldBuilder ?? passwordFieldBuilder,
      emailFieldBuilder: themeData?.emailFieldBuilder ?? emailFieldBuilder,
      phoneFieldBuilder: themeData?.phoneFieldBuilder ?? phoneFieldBuilder,
      cpfFieldBuilder: themeData?.cpfFieldBuilder ?? cpfFieldBuilder,
      cnpjFieldBuilder: themeData?.cnpjFieldBuilder ?? cnpjFieldBuilder,
      checkboxFieldBuilder: themeData?.checkboxFieldBuilder ?? checkboxFieldBuilder,
      dropdownFieldBuilder: themeData?.dropdownFieldBuilder ?? dropdownFieldBuilder,
      dateTextFormFieldBuilder: themeData?.dateTextFormFieldBuilder ?? dateTextFormFieldBuilder,
      switchFormFieldBuilder: themeData?.switchFormFieldBuilder ?? switchFormFieldBuilder,
      fileFormFieldBuilder: themeData?.fileFormFieldBuilder ?? fileFormFieldBuilder,
      expandableFieldBuilder: themeData?.expandableFieldBuilder ?? expandableFieldBuilder,
      customFieldsBuilder: themeData?.customFieldsBuilder ?? customFieldsBuilder,
      runningSpacing: themeData?.runningSpacing ?? runningSpacing,
      verticalSpacing: themeData?.verticalSpacing ?? verticalSpacing,
      formHeaderBuilder: themeData?.formHeaderBuilder ?? formHeaderBuilder,
      subformHeaderBuilder: themeData?.subformHeaderBuilder ?? subformHeaderBuilder,
      tableFieldStyle: themeData?.tableFieldStyle ?? tableFieldStyle,
    );
  }


  static Widget defaultTextFormFieldBuilder(BaseTextFieldState state) => DefaultTextFieldBuilder(state: state);
  static Widget defaultPasswordFormFieldBuilder(PasswordFieldState state) => DefaultPasswordTextFieldBuilder(state: state);
  static Widget defaultCheckboxFormFieldBuilder(CheckboxFieldState state) => DefaultCheckboxFieldBuilder(state: state);
  static Widget defaultSwitchFormFieldBuilder(SwitchFieldState state) => DefaultSwitchFieldBuilder(state: state);
  static Widget defaultDropdownFormFieldBuilder<T extends Object>(DropdownFieldState<T> state) => DefaultDropdownFieldBuilder(state: state);
  static Widget defaultFilePickerFormFieldBuilder(FilePickerFieldState state) => DefaultFilePickerBuilder(state: state);
  static Widget defaultFormHeaderBuilder(FormModel form) => _DefaultFormHeaderBuilder(form: form);
  static Widget defaultSubformHeaderBuilder(FormModel subform) => _DefaultSubFormHeaderBuilder(subform: subform);
  static Widget defaultExpandableFieldBuilder(ExpandableBaseFieldState state) => BuildExpandableField(state: state);

}


class DynamicFormTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  const DynamicFormTheme({Key? key, required this.data, required super.child})
      : super(key: key);

  final DynamicFormThemeData data;


  /// The data from the closest [SfDataGridTheme]
  /// instance that encloses the given context.
  ///
  /// Defaults to [SfThemeData.dataGridThemeData] if there
  /// is no [SfDataGridTheme] in the given build context.
  ///
  static DynamicFormThemeData of(BuildContext context) {
    final DynamicFormTheme? sfDataGridTheme = context.dependOnInheritedWidgetOfExactType<DynamicFormTheme>();
    return sfDataGridTheme?.data ?? const DynamicFormThemeData();
  }

  @override
  bool updateShouldNotify(DynamicFormTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final DynamicFormTheme? ancestorTheme =
    context.findAncestorWidgetOfExactType<DynamicFormTheme>();
    return identical(this, ancestorTheme)
        ? child
        : DynamicFormTheme(data: data.lerp(themeData: ancestorTheme?.data), child: child);
  }
}


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

class DynamicForm extends StatelessWidget {

  const DynamicForm({super.key,
    required this.controller,
    this.style,
  });

  final FormController controller;
  final DynamicFormThemeData? style;

  @override
  Widget build(BuildContext context) {

    var style = this.style ?? DynamicFormTheme.of(context);

    return DynamicFormTheme(
        data: style,
        child: Builder(
          builder: (_) {
            if (controller is MultipleFormController) {

              return AnimatedBuilder(
                  animation: controller as MultipleFormController,
                  builder: (context, child) {
                    var forms = (controller as MultipleFormController).forms;
                    return SeparatedColumn(
                      data: forms,
                      itemBuilder: (_,i) => FormBuilder(form: forms[i]),
                      separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
                    );
                  }
              );
            } else {
              return FormBuilder(form: (controller as SingleFormController).form);
            }
          },
        )
    );



  }
}

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
          data: form.subforms ?? [],
          itemBuilder: (_,i) => SubformBuilder(subform: form.subforms![i]),
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
          data: subform.subforms ?? [],
          itemBuilder: (_,i) => SubformBuilder(subform: subform.subforms![i]),
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

