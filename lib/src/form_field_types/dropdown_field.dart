
import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/form_field_configuration.dart';
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
    super.jsonEntryMapper,
    super.callback,
  }) : _options = options, super(configuration: configuration);

  List<T> get options => _options;
  set options(List<T> options) {
    if (options != this.options) {
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

typedef DropdownFormFieldBuilder<T extends Object> = Widget Function(DropdownFieldState<T> field);

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
  late final List<T> options;
  late Key _key;

  void optionsListener() {

    if (options != widget.state.options) {
      setState(() {
        options..clear()..addAll(widget.state.options);
        _controller.clear();
        _key = UniqueKey();
      });
    }

  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.state.value?.toString());
    options = List.from(widget.state.options);
    widget.state.addListener(optionsListener);
    _key = UniqueKey();
    super.initState();
  }


  @override
  void dispose() {
    widget.state.removeListener(optionsListener);
    _controller.dispose();
    super.dispose();
  }

  DropdownFieldConfiguration get config => widget.state.configuration;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, dimens) {

        return DropdownMenu(
            key: _key,
            controller: _controller,
            width: dimens.maxWidth,
            onSelected: (value) => widget.state.value = value,
            hintText: config.hint ?? config.label,
            initialSelection: widget.state.value,
            enabled: widget.state.enabled,
            errorText: widget.state.error,
            dropdownMenuEntries: options
                .map((e) => widget.entryBuilder?.call(e) ?? DropdownMenuEntry(
                    value: e,
                    label: config.customLabel?.call(e) ?? e.toString(),
            ))
                .toList()
        );
      }
    );
  }
}
