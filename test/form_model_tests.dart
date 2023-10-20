

import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("findByKey", () {
    final FormModel form = FormModel(key: "key", fields: [[
      TextFieldState(key: "field1"),
    ],
      [
        TextFieldState(key: "field2"),
      ]
    ]);
    form.findByKey("field1");
    form.findByKey("field2");

    final FormModel formWithSubform = FormModel(key: "key", fields: [[
      TextFieldState(key: "field1"),
    ]],
      subforms: [
        FormModel(key: "subform", fields: [[
          TextFieldState(key: "field2"),
        ]])
      ]
    );

    formWithSubform.findByKey("field1");
    formWithSubform.findByKey("subform.field2");

  });

  test("Add field to form test", (){
    final FormModel form = FormModel(key: "key", fields: [[
      TextFieldState(key: "field1"),
    ]]);

    expect(form.fieldsMatrix.length, 1);
    expect(form.fieldsMatrix[0].length, 1);
    expect(form.expandedMainFields.length, 1);

    form.addRow([TextFieldState(key: "field2"), TextFieldState(key: "field3")]);

    expect(form.fieldsMatrix.length, 2);
    expect(form.fieldsMatrix[1].length, 2);
    expect(form.expandedMainFields.length, 3);

    form.addRowFields([TextFieldState(key: "field4")], 0);
    expect(form.fieldsMatrix[0].length, 2);
    expect(form.fieldsMatrix.length, 2);
    expect(form.expandedMainFields.length, 4);

  });

  test("RemoveRow test", () {
    final FormModel form = FormModel(key: "key", fields: [[
      TextFieldState(key: "field1"),
      TextFieldState(key: "field2"),
    ],[
      TextFieldState(key: "field3"),
      TextFieldState(key: "field4"),
      TextFieldState(key: "field5"),
    ],
      [TextFieldState(key: "field6"),]
    ]);

    expect(form.fieldsMatrix.length, 3);
    expect(form.fieldsMatrix[0].length, 2);
    expect(form.fieldsMatrix[1].length, 3);
    expect(form.fieldsMatrix[2].length, 1);
    expect(form.expandedMainFields.length, 6);

    form.removeRow(1);

    expect(form.fieldsMatrix.length, 2);
    expect(form.fieldsMatrix[0].length, 2);
    expect(form.fieldsMatrix[1].length, 1);
    expect(form.expandedMainFields.length, 3);
  });

  test("RemoveBellow test", () {
    final FormModel form = FormModel(key: "key", fields: [[
      TextFieldState(key: "field1"),
      TextFieldState(key: "field2"),
    ],[
      TextFieldState(key: "field3"),
      TextFieldState(key: "field4"),
      TextFieldState(key: "field5"),
    ],
      [TextFieldState(key: "field6"),]
    ]);

    form.removeBellow(1);

    expect(form.fieldsMatrix.length, 1);
    expect(form.fieldsMatrix[0].length, 2);
    expect(form.expandedMainFields.length, 2);
  });

  test("Add/Remove form validator test",() {

    final FormModel form = FormModel(key: "key", fields: [[
      CheckboxFieldState(key: "field1"),
      CheckboxFieldState(key: "field2"),
    ]]);

    final FormController controller = SingleFormController(form: form);

    expect(controller.isValid, false);
    form.addRow([  CheckboxFieldState(key: "field3")]);
    expect(controller.isValid, false);

    form.findByKey("field1").value = true;
    form.findByKey("field2").value = true;
    expect(controller.isValid, false);


    form.findByKey("field3").value = true;
    expect(controller.isValid, true);

    form.removeRow(0);
    expect(controller.isValid, true);
  });

  test("Add/Remove subform to form test", (){
    final FormModel form = FormModel(key: "key", fields: [[
      TextFieldState(key: "field1"),
    ]]);

    expect(form.subforms.length, 0);
    expect(form.allFields.length, 1);

   form.addSubForm(FormModel.singleField(field: CheckboxFieldState(key: "field2")));
   form.findByKey("field2.field2");

   expect(form.subforms.length, 1);
   expect(form.allFields.length, 2);

    form.removeSubForm(0);
    expect(form.subforms.length, 0);
    expect(form.allFields.length, 1);

  });


  test("Add/Remove subform validator form test", (){
    final FormModel form = FormModel(key: "key", fields: [[
      CheckboxFieldState(key: "field1"),
    ]]);

    final SingleFormController controller = SingleFormController(form: form);
    expect(controller.isValid, false);

    form.addSubForm(FormModel.singleField(field: CheckboxFieldState(key: "field2")));
    expect(controller.isValid, false);

    form.findByKey("field1").value = true;
    expect(controller.isValid, false);

    form.findByKey("field2.field2").value = true;
    expect(controller.isValid, true);

    form.removeSubForm(0);
    expect(controller.isValid, true);

    form.findByKey("field1").value = false;
    expect(controller.isValid, false);


  });





}
