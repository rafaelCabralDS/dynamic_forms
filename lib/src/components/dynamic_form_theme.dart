import 'package:dynamic_forms/src/components/form_builder.dart';
import 'package:dynamic_forms/src/form_field_types/autocompleter_field.dart';
import 'package:dynamic_forms/src/form_field_types/checkbox_field.dart';
import 'package:dynamic_forms/src/form_field_types/dropdown_field.dart';
import 'package:dynamic_forms/src/form_field_types/expandable_field.dart';
import 'package:dynamic_forms/src/form_field_types/file_field.dart';
import 'package:dynamic_forms/src/form_field_types/switcher_field.dart';
import 'package:dynamic_forms/src/form_field_types/table_field/table_components.dart';
import 'package:dynamic_forms/src/form_field_types/text_fields/text_field_base.dart';
import 'package:dynamic_forms/src/form_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide FormFieldBuilder;
export 'package:dynamic_forms/src/form_field_types/table_field/table_components.dart';

@immutable
class DynamicFormThemeData with Diagnosticable {

  static const factory = DynamicFormThemeData();

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
  final AutocompleteFieldStyle autocompleteFieldStyle;

  /// A map that overrides the default fields builders for specific field
  /// by the key value
  final Map<String, DynamicFormFieldBuilder>? customFieldsBuilder;

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
    this.autocompleteFieldStyle = AutocompleteFieldStyle.factory,
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
    AutocompleteFieldStyle? autocompleteFieldStyle,
    Map<String, DynamicFormFieldBuilder>? customFieldsBuilder,
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
      autocompleteFieldStyle: autocompleteFieldStyle ?? this.autocompleteFieldStyle,
    );
  }

  DynamicFormThemeData merge({
    DynamicFormThemeData? themeData,
  }) {
    return DynamicFormThemeData(
      autocompleteFieldStyle: themeData?.autocompleteFieldStyle ?? autocompleteFieldStyle,
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
  static Widget defaultFormHeaderBuilder(FormModel form) => DefaultFormHeaderBuilder(form: form);
  static Widget defaultSubformHeaderBuilder(FormModel subform) => DefaultSubFormHeaderBuilder(subform: subform);
  static Widget defaultExpandableFieldBuilder(ExpandableBaseFieldState state) => BuildExpandableField(state: state);
  static Widget defaultAutocompleteFieldBuilder(AutocompleteFieldState state) => AutocompleteFieldBuilder(state: state);

}

class DynamicFormTheme extends InheritedTheme {


  /// Applies the given theme [data] to [child].
  const DynamicFormTheme({Key? key, required this.data, required super.child})
      : super(key: key);

  final DynamicFormThemeData data;


  static DynamicFormThemeData of(BuildContext context) {
    final DynamicFormTheme? inheritedTheme = context.dependOnInheritedWidgetOfExactType<DynamicFormTheme>();
    return inheritedTheme?.data ?? DynamicFormThemeData.factory;

  }

  @override
  bool updateShouldNotify(DynamicFormTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final DynamicFormTheme? ancestorTheme =
    context.findAncestorWidgetOfExactType<DynamicFormTheme>();
    return identical(this, ancestorTheme)
        ? child
        : DynamicFormTheme(data: data.merge(themeData: ancestorTheme?.data), child: child);
  }
}