
import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_configuration.dart';
import 'package:flutter/material.dart';


final class DropdownFieldConfiguration<E extends Object> extends FormFieldConfiguration {

  static const String KEY_HINT = "hint";

  final String? hint;

  /// You can override the default value.toString() default label by providing
  /// a list of strings with the same size of the options
  final String Function(dynamic)? customLabel;

  const DropdownFieldConfiguration({
    super.label,
    super.flex,
    this.hint,
    this.customLabel,
  }) : super(formType: FormFieldType.dropdownMenu);

  static const DropdownFieldConfiguration factory = DropdownFieldConfiguration();

  factory DropdownFieldConfiguration.fromJSON(Map<String, dynamic> json) {
    return DropdownFieldConfiguration(
        label: json[FormFieldConfiguration.KEY_LABEL],
        flex: json[FormFieldConfiguration.KEY_FLEX],
        hint: json[DropdownFieldConfiguration.KEY_HINT]
    );
  }

}

final class DropdownFieldState<T extends Object> extends DynamicFormFieldState<T> {

  static const String KEY_OPTIONS = "options";

  final List<T> _options;

  DropdownFieldState({
    required super.key,
    required List<T> options,
    super.initialValue,
    super.enabled,
    DropdownFieldConfiguration configuration =  DropdownFieldConfiguration.factory,
    super.isRequired,
  }) : _options = options, super(configuration: configuration);

  List<T> get options => _options;
  set options(List<T> options) {
    if (({...options}.difference({...this.options}).isNotEmpty)) {
      value = null;
      _options..clear()..addAll(options);
      notifyListeners();
    }
  }


  @override
  bool get isValid => value != null;


  @override
  bool validator(T? v) => _options.contains(v);

  @override
  DropdownFieldConfiguration get configuration => super.configuration as DropdownFieldConfiguration;

  /// The data type of a json payload must be either a primitive type (string, int, etc)
  factory DropdownFieldState.fromJSON(Map<String, dynamic> json) => DropdownFieldState(
    key: json[DynamicFormFieldState.KEY_KEY],
    options: List.castFrom(json[DropdownFieldState.KEY_OPTIONS]),
    initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
    isRequired: json[DynamicFormFieldState.KEY_REQUIRED] ?? true,
    configuration: DropdownFieldConfiguration.fromJSON(json),
  );

}

class DefaultDropdownFieldBuilder<T extends Object> extends StatefulWidget {

  final DropdownFieldState<T> state;
  final DropdownMenuEntry Function(T option)? entryBuilder;

  const DefaultDropdownFieldBuilder({
    super.key,
    required this.state,
    this.entryBuilder,
  });

  @override
  State<DefaultDropdownFieldBuilder> createState() => _DefaultDropdownFieldBuilderState<T>();
}

class _DefaultDropdownFieldBuilderState<T extends Object> extends State<DefaultDropdownFieldBuilder<T>> {

  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.state.value?.toString());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return LayoutBuilder(
      builder: (context, dimens) {

        return DropdownMenu(
            controller: _controller,
            width: dimens.maxWidth,
            onSelected: (value) => widget.state.value = value,
            hintText: widget.state.configuration.hint,
            initialSelection: widget.state.value,
            enabled: widget.state.enabled,
            dropdownMenuEntries: widget.state.options
                .map((e) => widget.entryBuilder?.call(e) ?? DropdownMenuEntry(
                    value: e,
                    label: widget.state.configuration.customLabel?.call(e) ?? e.toString(),
            ))
                .toList()
        );
      }
    );
  }
}
