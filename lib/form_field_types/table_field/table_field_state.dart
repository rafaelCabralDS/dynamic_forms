
import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_configuration.dart';
import 'package:dynamic_forms/form_model.dart';

final class TableFieldConfiguration extends FormFieldConfiguration {

  const TableFieldConfiguration({
    super.flex,
    super.label,
  }) : super(
      formType: FormFieldType.table
  );

  factory TableFieldConfiguration.fromJSON(Map<String, dynamic> json) =>
      TableFieldConfiguration(
          label: json[FormFieldConfiguration.KEY_LABEL],
          flex: json[FormFieldConfiguration.KEY_FLEX],
      );
}

final class TableFieldState extends DynamicFormFieldState<List<FormModel>> {

  TableFieldState({
    required super.key,
    required this.dataFactory,
    super.isRequired,
    super.configuration = const TableFieldConfiguration()
  }) : super(
    initialValue: [dataFactory(0)],
  );

  factory TableFieldState.fromJSON(Map<String,dynamic> json) => throw UnimplementedError();

  /// This is the base model field that will be built at first
  final FormModel Function(int index) dataFactory;

  @override
  List<FormModel> get value => super.value!;

  List<String> get headers => dataFactory(-1).keys;

  FormModel get sample => dataFactory(-1);

  @override
  TableFieldConfiguration get configuration => super.configuration as TableFieldConfiguration;

  int get length => value.length;

  void add(FormModel e) {
    assert(FormModel.patternMatching(e, dataFactory(-1)), "The new data must follow the pre defined style");
    value.add(e);
    notifyListeners();
  }

  void addFactory() {
    value.add(dataFactory(length));
    notifyListeners();
  }

  void removeLast() {
    value.removeLast();
    notifyListeners();
  }

  void removeAt(int index) {
    value.removeAt(index);
    notifyListeners();
  }

  void insert(int i, FormModel e) {
    value.insert(i, e);
    notifyListeners();
  }

  @override
  bool validator(List<FormModel>? v) {
    assert(v != null);
    return v?.expand((element) => element.allFields).every((element) => element.isValid) ?? false;
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


}