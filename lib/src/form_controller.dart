

import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/form_model.dart';
import 'package:flutter/cupertino.dart';
import 'utils.dart';
export 'form_model.dart';

// An mixin class can be extended or used as with
abstract mixin class FormController {

  List<DynamicFormFieldState> get fields;
  List<DynamicFormFieldState> get requiredFields;
  List<DynamicFormFieldState> get optionalFields;

  bool get isValid {
    bool requiredAreReady = requiredFields.every((element) => element.isValid);
    bool optionalFieldsAreReady = optionalFields.where((element) => element.value != null).every((element) => element.isValid);
    return requiredAreReady && optionalFieldsAreReady;
  }

  bool validate({bool validateInBatch = true});

  void clearErrors();
  Map<String, dynamic> toJSON();
  T findByKey<T extends DynamicFormFieldState>(String key);
  void clear();

}

class SingleFormController extends FormController {

  FormModel form;
  SingleFormController({required this.form});

  /// Build your forms from a JSON structure
  factory SingleFormController.fromJSON(Map<String, dynamic> data) {
    return SingleFormController(form: FormModel.fromJSON(data));
  }

  @override
  List<DynamicFormFieldState> get fields => form.allFields;

  @override
  List<DynamicFormFieldState> get requiredFields =>  fields.where((element) => element.isRequired).toList();

  @override
  List<DynamicFormFieldState> get optionalFields =>  fields.where((element) => !element.isRequired).toList();

  @override
  bool validate({bool validateInBatch = true}) {

    if (validateInBatch) {
      for (var e in requiredFields) {
        e.validate();
      }
      for (var e in optionalFields.where((e) => e.value != null)) {
        e.validate();
      }
    }

    bool requiredAreReady = requiredFields.every((element) => element.isValid);
    bool optionalFieldsAreReady = optionalFields.where((element) => element.value != null).every((element) => element.isValid);
    return requiredAreReady && optionalFieldsAreReady;
  }

  @override
  void clearErrors() {
    for (var e in fields) {
      e.error = null;
    }
  }

  @override
  void clear() {
    for (var e in fields) {
      e.reset();
    }
  }

  @override
  T findByKey<T extends DynamicFormFieldState>(String key) {
    try {
      return fields.singleWhere((element) => element.key == key) as T;
    } catch (_) {
      throw Exception("There is no $key value on the current controller");
    }

  }

  void addListenersByKey(Map<String,void Function(DynamicFormFieldState)> listenersMap) {
    for (final entry in listenersMap.entries) {
      var node = findByKey(entry.key);
      node.addListener(() => entry.value(node));
    }
  }

  @override
  Map<String, dynamic> toJSON() => form.toJSON();

}

class MultipleFormController extends ChangeNotifier with FormController {

  MultipleFormController({
      required List<FormModel> forms,
  }) : _forms = forms, assert(forms.every((element) => element.key != null && element.key!.isNotEmpty)
      && forms.map((e) => e.key!).toList().getDuplicates().isEmpty, "There is some duplicated form keys");

  final List<FormModel> _forms;
  List<FormModel> get forms => _forms;

  @override
  List<DynamicFormFieldState> get fields => forms.expand((form) => form.allFields).toList();

  @override
  List<DynamicFormFieldState> get requiredFields =>  fields.where((element) => element.isRequired).toList();

  @override
  List<DynamicFormFieldState> get optionalFields =>  fields.where((element) => !element.isRequired).toList();



  @override
  bool validate({bool validateInBatch = true}) {
    if (validateInBatch) {
      for (var e in requiredFields) {
        e.validate();
      }
      for (var e in optionalFields.where((e) => e.value != null)) {
        e.validate();
      }
      return isValid;
    }

    // The validation stops on the first non valid field
    bool requiredAreReady = requiredFields.every((element) => element.validate());
    bool optionalFieldsAreReady = optionalFields.where((element) => element.value != null).every((element) => element.validate());
    return requiredAreReady && optionalFieldsAreReady;
  }

  @override
  void clearErrors() {
    for (var e in forms.expand((e) => e.allFields)){
      e.error = null;
    }
  }

  @override
  void clear() {
    for (var e in fields) {
      e.reset();
    }
  }

  void add(FormModel form) {
    assert(form.key != null && form.key!.isNotEmpty, "Only root forms can have a null key");
    assert(!_forms.map((e) => e.key).contains(form.key), "There is already a form by the key ${form.key}");
    //assert({fields.map((e) => e.key)}.difference({form.expandedMainFields.map((e) => e.key)}).isNotEmpty, "There is duplicates field keys");
    _forms.add(form);
    notifyListeners();
  }

  void addAll(List<FormModel> forms) {

    for (var form in forms) {
      assert(form.key != null && form.key!.isNotEmpty, "Only root forms can have a null key");
      assert(!_forms.map((e) => e.key).contains(form.key), "There is already a form by the key ${form.key}");
      _forms.add(form);
    }
    notifyListeners();
  }

  void insert(int i, FormModel form) {
    if (i >= 0 && i <= _forms.length) {
      _forms.insert(i, form);
      notifyListeners();
    }
  }

  void removeByKey(String key) {
    _forms.removeWhere((form) => form.key == key);
    notifyListeners();
  }

  void removeByIndex(int i) {

    if (i >= 0 && i < _forms.length) {
      _forms.removeAt(i);
      notifyListeners();
    }
  }

  void popUntilKey(String key, {bool inclusive = false}) {
    final reversedForms = _forms.reversed.toList();
    final index = reversedForms.indexWhere((form) => form.key == key);

    if (index != -1) {
      final indexToRemove = _forms.length - 1 - index;

      if (inclusive) {
        _forms.removeRange(indexToRemove, _forms.length);
      } else {
        _forms.removeRange(indexToRemove + 1, _forms.length);
      }

      notifyListeners();
    }
  }

  FormModel getFormByKey(String key) {

    try {
      return _forms.firstWhere((form) => form.key == key);
    } catch (_) {
      throw Exception("There is no $key form in this controller");
    }
  }

  @override
  T findByKey<T extends DynamicFormFieldState>(String fieldKey) {

    try {
      var keys = fieldKey.split(".");
      var form = getFormByKey(keys[0]);

      return (form.isSingleFormField
          ? form.allFields.first
          : form.findByKey(keys.sublist(1).join("."))) as T;

    } catch (_) {
      throw Exception("There is no $fieldKey field in this controller");
    }
  }

  @override
  Map<String, dynamic> toJSON() {

    var data = <String, dynamic>{};
    for (var form in _forms) {

      if (form.shouldShrink) {
        data.addAll(form.toJSON());
      } else {
        data[form.key!] = form.isSingleFormField ? form.allFields[0].asJsonEntry().value : form.toJSON();
      }

    }
    return data;
  }


}