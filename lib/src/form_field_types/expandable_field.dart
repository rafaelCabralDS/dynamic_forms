import 'package:dynamic_forms/src/components/dynamic_form_theme.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:dynamic_forms/src/components/form_builder.dart';
import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/utils.dart';
import 'package:flutter/material.dart';

final class ExpandableFieldConfiguration extends FormFieldConfiguration {

  static const String KEY_MIN_FIELDS = 'min';
  static const String KEY_MAX_FIELDS = 'max';

  final int minFields;
  final int? maxFields;

  const ExpandableFieldConfiguration({
    super.flex,
    super.label,
    this.minFields = 1,
    this.maxFields,
  }) : assert(minFields > 0), super(
    formType: FormFieldType.expandable
  );

  factory ExpandableFieldConfiguration.fromJSON(Map<String, dynamic> json) =>
      ExpandableFieldConfiguration(
        label: json[FormFieldConfiguration.KEY_LABEL],
        flex: json[FormFieldConfiguration.KEY_FLEX],
        maxFields: json[KEY_MAX_FIELDS],
        minFields: json[KEY_MIN_FIELDS]
      );

}

abstract base class ExpandableBaseFieldState<T> extends DynamicFormFieldState<List<T>> {

  ExpandableBaseFieldState({
    required super.key,
    super.configuration = const ExpandableFieldConfiguration(),
    super.isRequired,
    required this.dataFactory,
    super.jsonEntryMapper,
  }) : super(
    initialValue: [dataFactory(0)],
  ) {
    _internalListener(value.first);
  }


  @override
  List<T> get value => super.value!;

  @override
  ExpandableFieldConfiguration get configuration => super.configuration as ExpandableFieldConfiguration;

  int get length => value.length;

  /// This is the base model field that will be built at first
  final T Function(int index) dataFactory;

  /// Make sure that children changes are propagated to the parent and manage memory (DO NOT CHANGE)
  void _listener() => () => notifyListeners();
  void _internalListener(T item);
  void _killListener(T item);

  void add(T e) {
    if (length == configuration.maxFields) return;
    value.add(e);
    _internalListener(e);
    notifyListeners();
  }

  void addFactory() {
    if (length == configuration.maxFields) return;
    var e = dataFactory(length);
    value.add(e);
    _internalListener(e);
    notifyListeners();
  }

  void removeLast() {
    if (length == configuration.minFields) return;
    _killListener(value.last);
    value.removeLast();
    notifyListeners();
  }

  void removeAt(int index) {
    if (length == configuration.minFields) return;
    _killListener(value[index]);
    value.removeAt(index);
    notifyListeners();
  }

  void insert(int i, T e) {
    if (length == configuration.maxFields) return;
    value.insert(i, e);
    _internalListener(e);
    notifyListeners();
  }

  @override
  MapEntry<String, dynamic> asJsonEntry();

}

final class ExpandableFieldState<E> extends ExpandableBaseFieldState<DynamicFormFieldState<E>> {

  ExpandableFieldState({
    required super.key,
    required super.dataFactory,
    super.configuration = const ExpandableFieldConfiguration(),
    super.isRequired,
    super.jsonEntryMapper,
  }) : super();

  factory ExpandableFieldState.fromJSON(Map<String, dynamic> json) => throw UnimplementedError();



  @override
  void _internalListener(DynamicFormFieldState item) => item.addListener(_listener);

  @override
  void _killListener(DynamicFormFieldState<E> item) {
    item.removeListener(_listener);
  }

  
  @override
  bool validator(List<DynamicFormFieldState>? v) {
    return v?.every((element) => element.isValid) ?? false;
  }
  
  @override
  bool validate([String invalidMsg = "Campo inválido"]) {
    for (var e in value) {
      e.validate();
    }
    return isValid;
  }

  @override
  MapEntry<String, dynamic> asJsonEntry() {
    return MapEntry(key, value.map((e) => e.asJsonEntry().value).toList());
  }

}

final class ExpandableFormFieldState extends ExpandableBaseFieldState<FormModel> {

  ExpandableFormFieldState({
    required super.key,
    required super.dataFactory,
    super.isRequired,
    super.configuration = const ExpandableFieldConfiguration(),
    super.jsonEntryMapper,
  });



  @override
  void _killListener(FormModel item) {
    for (var field in item.allFields) {
      field.removeListener(_listener);
    }
  }

  @override
  void _internalListener(FormModel item) {
    for (var field in item.allFields) {
      field.addListener(_listener);
    }
  }



  @override
  bool validator(List<FormModel>? v) {
    assert(v != null);
    return v!.expand((element) => element.allFields).every((element) => element.isValid);
  }

  @override
  bool validate([String invalidMsg = "Campo inválido"]) {
    for (var e in value.expand((element) => element.allFields)) {
      e.validate();
    }
    return isValid;
  }

  @override
  MapEntry<String, dynamic> asJsonEntry() {
    return MapEntry(key, value.map((e) => e.toJSON()).toList());
  }

  @override
  String toString() {
    return value.join("\n");
  }

}

typedef ExpandableFieldBuilder = Widget Function(ExpandableBaseFieldState field);

class BuildExpandableField extends StatelessWidget {

  final ExpandableBaseFieldState state;

  const BuildExpandableField({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {

    var style = DynamicFormTheme.of(context);


    return Column(
      children: [

        if (state is ExpandableFormFieldState)
            SeparatedColumn(
              data: state.value,
              itemBuilder: (_,i) => Row(
                children: [

                  Expanded(child: SubformBuilder(subform: state.value[i])),

                  if (state.length > state.configuration.minFields)
                    TextButton(
                        onPressed: () => state.removeAt(i),
                        child: const Icon(Icons.close_rounded)
                    ),
                ],
              ),
              separatorBuilder: (_,i) => SizedBox(height: style.verticalSpacing),
            ),


        if (state is ExpandableFieldState)
          FormFieldsBuilder(
              fields: (state as ExpandableFieldState).value.map((e) => [e]).toList(),
              style: style
          ),

        const SizedBox(height: 20.0),

        if (state.configuration.maxFields == null || state.length < state.configuration.maxFields!)
          TextButton(
              onPressed: () => state.add(state.dataFactory(state.length)),
              style: ButtonStyle(
                side: MaterialStatePropertyAll(BorderSide(width: 2, color: Theme.of(context).colorScheme.secondary)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                fixedSize: const MaterialStatePropertyAll(Size.square(30.0))
              ),
              child: const Icon(Icons.add_rounded),
          ),


      ],
    );
  }
}


