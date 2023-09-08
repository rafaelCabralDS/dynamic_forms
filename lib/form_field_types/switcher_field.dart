import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_configuration.dart';
import 'package:flutter/material.dart';

final class SwitcherFieldState extends DynamicFormFieldState<bool> {
  SwitcherFieldState({
    required super.key,
    super.initialValue = false,
    super.enabled,
    SwitcherFieldConfiguration configuration =
        SwitcherFieldConfiguration.factory,
    super.isRequired,
  }) : super(configuration: configuration);

  @override
  bool get value => super.value!;

  @override
  bool get isValid => value;

  @override
  SwitcherFieldConfiguration get configuration =>
      super.configuration as SwitcherFieldConfiguration;

  factory SwitcherFieldState.fromJSON(Map<String, dynamic> json) =>
      SwitcherFieldState(
        key: json[DynamicFormFieldState.KEY_KEY],
        initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
        isRequired: json[DynamicFormFieldState.KEY_REQUIRED] ?? true,
        configuration: SwitcherFieldConfiguration.fromJSON(json),
      );
}

final class SwitcherFieldConfiguration extends FormFieldConfiguration {
  static const String KEY_DESCRIPTION = "description";

  final TextSpan? description;

  const SwitcherFieldConfiguration({
    super.label,
    super.flex,
    this.description,
  }) : super(formType: FormFieldType.switcher);

  static const factory = SwitcherFieldConfiguration();

  factory SwitcherFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return SwitcherFieldConfiguration(
        label: json[FormFieldConfiguration.KEY_LABEL],
        flex: json[FormFieldConfiguration.KEY_FLEX],
        description: TextSpan(text: json[KEY_DESCRIPTION]));
  }
}
