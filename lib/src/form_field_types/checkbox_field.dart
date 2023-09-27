import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/form_field_configuration.dart';
import 'package:flutter/material.dart';

final class CheckboxFieldConfiguration extends FormFieldConfiguration {

  static const String KEY_DESCRIPTION = "description";

  final TextSpan? description;

  const CheckboxFieldConfiguration({
    super.label,
    super.flex,
    this.description,

  }) : super(formType: FormFieldType.checkbox);

  static const factory = CheckboxFieldConfiguration();

  factory CheckboxFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return CheckboxFieldConfiguration(
        label: json[FormFieldConfiguration.KEY_LABEL],
        flex: json[FormFieldConfiguration.KEY_FLEX],
        description: TextSpan(text: json[KEY_DESCRIPTION])
    );
  }

}

final class CheckboxFieldState extends DynamicFormFieldState<bool> {

  CheckboxFieldState({
    required super.key,
    super.initialValue = false,
    super.enabled,
    super.callback,
   CheckboxFieldConfiguration configuration = CheckboxFieldConfiguration.factory,
    super.isRequired,
  }) : super(configuration: configuration);

  @override
  bool get value => super.value!;

  @override
  void reset() {
    if (value == false) return;
    value = false;
  }

  @override
  bool validator(bool? v) => v == true;

  @override
  CheckboxFieldConfiguration get configuration => super.configuration as CheckboxFieldConfiguration;

  factory CheckboxFieldState.fromJSON(Map<String, dynamic> json) => CheckboxFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED] ?? true,
      configuration: CheckboxFieldConfiguration.fromJSON(json),
  );

}


typedef CheckboxFormFieldBuilder = Widget Function(CheckboxFieldState field);

class DefaultCheckboxFieldBuilder extends StatelessWidget {

  final CheckboxFieldState state;

  const DefaultCheckboxFieldBuilder({super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: state.value,
            onChanged: (v) => state.value = !state.value,
        ),
       if (state.configuration.description != null)
        Text.rich(state.configuration.description!)
      ],
    );
  }
}
