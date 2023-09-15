

import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/utils.dart';
import 'package:collection/collection.dart';
class FormModel {

  static const String FORM_KEY = "form"; // Field name
  static const String FORM_TITLE_KEY = "title"; // String?
  static const String FORM_DESC_KEY = "description"; // String?
  static const String FORM_FIELDS_KEY = "fields"; // List<List<Map<String, dynamic>>>

  /// The form key is the json key of the form, if it is null it means that this form is the parent
  /// All subforms must have a key defined, where a subform will become a map

  final String? key;

  final String? title;
  final String? desc;
  late final List<List<DynamicFormFieldState>> _fields;
  late final List<FormModel>? subforms;

  List<List<DynamicFormFieldState>> get fieldsMatrix => _fields;

  /// Return the fields in the main form only (Not the fields from the subform)
  List<DynamicFormFieldState> get expandedMainFields => _fields.expand((e) => e).where((e) => !e.key.startsWith("_")).toList();

  /// All fields in the entire tree
  /// Note: it might have repeated keys in this list, since it cant only be repeated keys in the same level
  /// but not in different levels (Ex: two distinct subforms with a shared key field name)
  List<DynamicFormFieldState> get allFields {
    final List<DynamicFormFieldState> data = List.from(expandedMainFields);
    for (final FormModel subform in (subforms ?? [])) {
      data.addAll(subform.allFields);
    }
    return data;
  }

  /// A single field contains only one field that is not a subform
  bool get isSingleFormField => allFields.length == 1 && key == allFields[0].key;

  /// The list of keys in the first layer. Does not include subform field keys neither private keys
  List<String> get keys => expandedMainFields.map((e) => e.key).toList();

  FormModel._({
    required this.key,
    this.title,
    this.desc,
    this.subforms,
    required List<List<DynamicFormFieldState>> fields,
  }) : _fields = fields {
    var duplicates = fields.expand((element) => element).map((e) => e.key).toList().getDuplicates();
    assert(duplicates.isEmpty, "As chaves $duplicates estão repetidas ao menos uma vez");
    assert(key == null || (subforms?.every((e) => e.key != null) ?? true),
    "The parent form key must be null while all subforms keys must be defined");

    /*
    _fields = [];
    for (List<DynamicFormFieldState> outerList in fields) {
      var mappedOuter = [];
      for (DynamicFormFieldState field in outerList) {
        mappedOuter.add(field.copyWith(parentKey: key));
      }
    }

     */

  }

  FormModel({
    required String? key,
    String? title,
    String? desc,
    List<FormModel>? subforms,
    required List<List<DynamicFormFieldState>> fields,
  }) : this._(
    key: key,
    fields: fields,
    title: title,
    desc: desc,
    subforms: subforms,
  );

  FormModel.singleField({
    String? title,
    String? desc,
    required DynamicFormFieldState field,
  }) : this._(
    key: field.key,
    fields: [[field]],
    title: title,
    desc: desc,
    subforms: null,
  );


  FormModel.vertical({
    required String? key,
    String? title,
    String? desc,
    List<FormModel>? subforms,
    required List<DynamicFormFieldState> fields}) : this._(
    key: key,
    title: title,
    desc: desc,
    subforms: subforms,
    fields: fields.map((field) => [field]).toList(),
  );


  FormModel.horizontal({
    required String? key,
    String? title,
    String? desc,
    required List<DynamicFormFieldState> fields}) : this._(
    key: key,
    title: title,
    desc: desc,
    subforms: [],
    fields: [fields],
  );

  FormModel copyWith({
    String? key,
    String? title,
    String? desc,
    List<FormModel>? subforms,
    List<List<DynamicFormFieldState>>? fields,
  }) => FormModel(
    key: key ?? this.key,
    fields: fields ?? fieldsMatrix,
    title: title ?? this.title,
    desc: desc ?? this.desc,
    subforms: subforms ?? this.subforms,
  );

  factory FormModel.fromJSON(Map<String, dynamic> data) {

    var fieldsAsMaps =  (data[FORM_FIELDS_KEY] as List<List<Map<String, dynamic>>>);
    var mappedFields = fieldsAsMaps.map((rows) => rows.map((column) => DynamicFormFieldState.fromJSON(column)).toList()).toList();

    return FormModel(
      key: data[FORM_KEY],
      title: data[FORM_TITLE_KEY],
      desc: data[FORM_DESC_KEY],
      fields: mappedFields,
    );
  }

  /// Maps the form inputs as JSON structure
  Map<String, dynamic> toJSON() {
    var data = Map.fromEntries(expandedMainFields.map((e) => e.asJsonEntry()));

    for (FormModel subform in subforms ?? []) {
      var fields = subform.expandedMainFields;

      // Reduce single fields where the json structure looks like
      // [fieldKey: {fieldKey: fieldValue}] to [fieldKey: fieldValue]
      var isSingleField = fields.length == 1 && fields[0].key == subform.key;

      data[subform.key!] = isSingleField
          ? fields.first.asJsonEntry().value
          : subform.toJSON();
    }
    return data;
  }

  DynamicFormFieldState<T> findByKey<T>(String key) {

    try {
      return _findByKey(this, key);
    } catch (_) {
      throw Exception("There is no $key value on the current controller");
    }
  }

  /// Internal implementation for the [findByKey] method
  DynamicFormFieldState<T> _findByKey<T>(FormModel root, String key) {

    var keyTree = key.split(".");

    if (keyTree.length == 1) {
      return root._fields.expand((e) => e).singleWhere((element) => element.key == key) as DynamicFormFieldState<T>;
    }
    var subform = subforms!.singleWhere((element) => element.key == keyTree[0]);
    return _findByKey(subform, keyTree.sublist(1).join("."));
  }


  void autofill(Map<String, dynamic> json) {

    for (final entry in json.entries.where((element) => element.value != null)) {
      try {
        var field = findByKey(entry.key);
        field.autofill(entry.value);
      } catch (_) {} // there is no field to fill
    }
  }

  void clear() {
    for (var field in allFields) {
      field.reset();
    }
  }

  static bool patternMatching(FormModel v1, FormModel v2) {

    var sameKeys = {v1.expandedMainFields.map((e) => e.key)}
        .difference({v2.expandedMainFields.map((e) => e.key)}).isEmpty;

    if (!sameKeys) return false;

    var sameTypes = {v1.expandedMainFields.map((e) => MapEntry(e.key, e.runtimeType))}
        .difference({v2.expandedMainFields.map((e) => MapEntry(e.key, e.runtimeType))}).isEmpty;

    if (!sameTypes) return false;

    for (FormModel subform1 in v1.subforms ?? []) {

      var matchingSubform = v2.subforms?.singleWhereOrNull((e) => e.key == subform1.key);
      if (matchingSubform == null) return false;

      var subformMatches = patternMatching(subform1, matchingSubform);
      if (!subformMatches) return false;
    }
    return true;
  }

}
