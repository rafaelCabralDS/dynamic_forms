

import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:dynamic_forms/src/field_state.dart';
import 'package:flutter/material.dart';

/// A field that can either select from options or insert a new option

final class AutocompleteFieldConfiguration extends FormFieldConfiguration {

  static const SUFFIX_KEY = "suffix";

  final IconData? suffixIcon;

  const AutocompleteFieldConfiguration({
    super.flex,
    super.label,
    this.suffixIcon,
  }): super(formType: FormFieldType.autocomplete);

  static const AutocompleteFieldConfiguration factory = AutocompleteFieldConfiguration();

}

final class AutocompleteFieldState extends DynamicFormFieldState<String?> {

  final List<String> options;

  AutocompleteFieldState({
    required super.key,
    required this.options,
    super.initialValue,
    AutocompleteFieldConfiguration configuration = AutocompleteFieldConfiguration.factory,
    super.isRequired,
    super.enabled,
    super.jsonEntryMapper,
    super.callback,
  }) : super(
      configuration: configuration
  );

  factory AutocompleteFieldState.fromJSON(Map<String, dynamic> json) => throw UnimplementedError();

  @override
  AutocompleteFieldConfiguration get configuration => super.configuration as AutocompleteFieldConfiguration;

  @override
  bool validator(String? v) => v != null && v.isNotEmpty;

}

typedef AutocompleteTextFormFieldBuilder = Widget Function(AutocompleteFieldState field);

class DefaultAutocompleteTextFieldBuilder extends StatefulWidget {

  final AutocompleteFieldState state;

  const DefaultAutocompleteTextFieldBuilder({super.key, required this.state});

  @override
  State<DefaultAutocompleteTextFieldBuilder> createState() => _DefaultAutocompleteTextFieldBuilderState();
}

class _DefaultAutocompleteTextFieldBuilderState extends State<DefaultAutocompleteTextFieldBuilder> {

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
        initialValue: TextEditingValue(text: widget.state.value ?? ""),
        optionsBuilder: (TextEditingValue value) {
          
          if (value.text.isEmpty) {
            return widget.state.options;
          }
          
          return widget.state.options.where((element) => (element.toLowerCase()).startsWith(value.text.toLowerCase()));
          
        },
        onSelected: (v) => widget.state.value = v,
        fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) => TextField(
          controller: textController,
          focusNode: focusNode,
          onChanged: (v) => widget.state.value = v,
          enabled: widget.state.enabled,
          decoration: InputDecoration(
            labelText: widget.state.configuration.label ?? widget.state.key,
            errorText: widget.state.error,
            hintText: widget.state.configuration.label,
            suffixIcon: Icon(widget.state.configuration.suffixIcon),
          ),
        ),
    );
  }
}
