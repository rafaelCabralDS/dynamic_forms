import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/form_field_configuration.dart';
import 'package:flutter/material.dart';

final class SwitchFieldState extends DynamicFormFieldState<bool> {
  SwitchFieldState({
    required super.key,
    super.initialValue = false,
    super.enabled,
    SwitcherFieldConfiguration configuration = SwitcherFieldConfiguration.factory,
    super.isRequired,
    super.callback,
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
  SwitcherFieldConfiguration get configuration => super.configuration as SwitcherFieldConfiguration;

  factory SwitchFieldState.fromJSON(Map<String, dynamic> json) =>
      SwitchFieldState(
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
        description: TextSpan(text: json[KEY_DESCRIPTION])
    );
  }
}


/// /////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef SwitcherFormFieldBuilder = Widget Function(SwitchFieldState field);

class DefaultSwitchFieldBuilder extends StatelessWidget {

  final SwitchFieldState state;

  const DefaultSwitchFieldBuilder({super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: state.value,
          onChanged: (v) => state.value = !state.value,
        ),
        if (state.configuration.description != null)
          Text.rich(state.configuration.description!)
      ],
    );
  }
}

