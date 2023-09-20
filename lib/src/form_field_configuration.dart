
import 'package:dynamic_forms/src/form_field_types/checkbox_field.dart';
import 'package:dynamic_forms/src/form_field_types/dropdown_field.dart';
import 'package:dynamic_forms/src/form_field_types/expandable_field.dart';
import 'package:dynamic_forms/src/form_field_types/file_field.dart';
import 'package:dynamic_forms/src/form_field_types/switcher_field.dart';
import 'package:dynamic_forms/src/form_field_types/table_field/table_field_state.dart';
import 'package:dynamic_forms/src/form_field_types/text_fields/text_field_base.dart';



enum FormFieldType {
  textField("text_field"),
  switcher("switcher"),
  checkbox("checkbox"),
  dropdownMenu("dropdown"),
  file("file"),
  expandable("expandable"),
  table("table");

  final String key;
  const FormFieldType(this.key);

  static FormFieldType fromString(String value) {
    for (final FormFieldType e in FormFieldType.values) {
      if (e.key == value) return e;
    }
    throw UnimplementedError();
  }
}

/// Describe properties about a form field
base class FormFieldConfiguration {

  static const String KEY_FIELD_TYPE = "field_type";
  static const String KEY_LABEL = "label";
  static const String KEY_FLEX = "flex";

  final FormFieldType formType;

  /// If not defined, the field [key] value will be used
  final String? label;

  /// If the field is in a row, it is possible to change the width of each
  /// by defining an flex value of the expanded element in the row.
  /// Default is all fields take the same space
  final int? flex;


  const FormFieldConfiguration( {
    required this.formType,
    this.label,
    this.flex,
  });

  factory FormFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    var fieldType = FormFieldType.fromString(json[FormFieldConfiguration.KEY_FIELD_TYPE]);

    switch (fieldType) {
      case FormFieldType.textField: return BaseTextFormFieldConfiguration.fromJSON(json);
      case FormFieldType.checkbox:  return CheckboxFieldConfiguration.fromJSON(json);
      case FormFieldType.switcher: return SwitcherFieldConfiguration.fromJSON(json);
      case FormFieldType.dropdownMenu: return DropdownFieldConfiguration.fromJSON(json);
      case FormFieldType.file: return FileFieldConfiguration.fromJSON(json);
      case FormFieldType.expandable: return ExpandableFieldConfiguration.fromJSON(json);
      case FormFieldType.table: return TableFieldConfiguration.fromJSON(json);
    }
  }


}





