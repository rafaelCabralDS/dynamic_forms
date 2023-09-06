import 'package:dynamic_forms/form_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('Getting a form by key', () {
    final form1 = FormModel(key: 'form1', title: 'Form 1', fields: []);
    final form2 = FormModel(key: 'form2', title: 'Form 2', fields: []);
    final form3 = FormModel(key: 'form3', title: 'Form 3', fields: []);

    final controller = MultipleFormController(forms: [form1, form2, form3]);

    final result = controller.getByKey('form2');

    expect(result, isNotNull);
    expect(result.title, 'Form 2');
  });

  test('Getting a form by non-existing key', () {
    final form1 = FormModel(key: 'form1', title: 'Form 1', fields: []);
    final form2 = FormModel(key: 'form2', title: 'Form 2', fields: []);
    final form3 = FormModel(key: 'form3', title: 'Form 3', fields: []);

    final controller = MultipleFormController(forms: [form1, form2, form3]);

    expect(controller.getByKey('nonexistent_key'), throwsException);
  });

  test('Adding a form to the controller', () {
    final form1 = FormModel(key: 'form1', title: 'Form 1', fields: []);
    final form2 = FormModel(key: 'form2', title: 'Form 2', fields: []);

    final controller = MultipleFormController(forms: [form1]);

    expect(controller.forms.length, 1);

    controller.add(form2);

    expect(controller.forms.length, 2);
    expect(controller.forms[1].title, 'Form 2');
  });

  test('Inserting a form at a specific index', () {
    final form1 = FormModel(key: 'form1', title: 'Form 1', fields: []);
    final form2 = FormModel(key: 'form2', title: 'Form 2', fields: []);
    final form3 = FormModel(key: 'form3', title: 'Form 3', fields: []);

    final controller = MultipleFormController(forms: [form1, form2]);

    expect(controller.forms.length, 2);

    controller.insert(1, form3);

    expect(controller.forms.length, 3);
    expect(controller.forms[1].title, 'Form 3');
  });

  test('Removing a form by key', () {
    final form1 = FormModel(key: 'form1', title: 'Form 1', fields: []);
    final form2 = FormModel(key: 'form2', title: 'Form 2', fields: []);

    final controller = MultipleFormController(forms: [form1, form2]);

    expect(controller.forms.length, 2);

    controller.removeByKey('form1');

    expect(controller.forms.length, 1);
    expect(controller.forms[0].title, 'Form 2');
  });

  test('Removing a form by index', () {
    final form1 = FormModel(key: 'form1', title: 'Form 1', fields: []);
    final form2 = FormModel(key: 'form2', title: 'Form 2', fields: []);
    final form3 = FormModel(key: 'form3', title: 'Form 3', fields: []);

    final controller = MultipleFormController(forms: [form1, form2, form3]);

    expect(controller.forms.length, 3);

    controller.removeByIndex(1);

    expect(controller.forms.length, 2);
    expect(controller.forms[1].title, 'Form 3');
  });

  test('Popping forms until a specific key', () {
    final form1 = FormModel(key: 'form1', title: 'Form 1', fields: []);
    final form2 = FormModel(key: 'form2', title: 'Form 2', fields: []);
    final form3 = FormModel(key: 'form3', title: 'Form 3', fields: []);

    final controller = MultipleFormController(forms: [form1, form2, form3]);

    expect(controller.forms.length, 3);

    controller.popUntilKey('form2', inclusive: true);

    expect(controller.forms.length, 1);
    expect(controller.forms[0].title, 'Form 1');

    controller.add(form2);
    controller.add(form3);
    expect(controller.forms.length, 3);

    controller.popUntilKey('form2', inclusive: false);

    expect(controller.forms.length, 2);
    expect(controller.forms[0].title, 'Form 1');
    expect(controller.forms[1].title, 'Form 2');



  });

  test('Popping forms until a specific index', () {
    final form1 = FormModel(key: 'form1', title: 'Form 1', fields: []);
    final form2 = FormModel(key: 'form2', title: 'Form 2', fields: []);
    final form3 = FormModel(key: 'form3', title: 'Form 3', fields: []);

    final controller = MultipleFormController(forms: [form1, form2, form3]);

    expect(controller.forms.length, 3);

   // controller.popUntilIndex(1, inclusive: true);

    expect(controller.forms.length, 2);
    expect(controller.forms[1].title, 'Form 2');

  });


}
