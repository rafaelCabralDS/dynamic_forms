import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("input test", ()  {

    final ExpandableFormFieldState state = ExpandableFormFieldState(
        key: "key",
        dataFactory: (i) => FormModel.vertical(
            key: "$i" ,
            fields: [TextFieldState(key: "text"), CheckboxFieldState(key: "checkbox")]
        )
    );

    var textField = state.value[0].findByKey("text");
    var checkboxField = state.value[0].findByKey("checkbox");

    expect(textField.value, null);
    expect(checkboxField.value, false);

    textField.value = "v";
    expect(textField.value, "v");

    checkboxField.value = true;
    expect(checkboxField.value, true);

  });

  test("factory json test", ()  {

    final ExpandableFormFieldState state = ExpandableFormFieldState(
        key: "key",
        dataFactory: (i) => FormModel.vertical(
            key: "$i" ,
            fields: [TextFieldState(key: "text"), CheckboxFieldState(key: "checkbox")]
        )
    );

    var textField = state.value[0].findByKey("text");
    var checkboxField = state.value[0].findByKey("checkbox");

    textField.value = "v";
    checkboxField.value = true;

    var expected = <String, dynamic>{
      "text": "v",
      "checkbox": true,
    };

    expect(state.value[0].toJSON(), expected);
    print(state.value[0].toJSON());
  });

  test("expanded json test", ()  {

    final ExpandableFormFieldState state = ExpandableFormFieldState(
        key: "key",
        dataFactory: (i) => FormModel.vertical(
            key: "$i" ,
            fields: [TextFieldState(key: "text"), CheckboxFieldState(key: "checkbox")]
        )
    );

    var textField = state.value[0].findByKey("text");
    var checkboxField = state.value[0].findByKey("checkbox");

    textField.value = "v";
    checkboxField.value = true;

    var expected = <String, dynamic>{
      "text": "v",
      "checkbox": true,
    };

    print(state.asJsonEntry());
    expect(state.asJsonEntry(), MapEntry<String, dynamic>("key", [expected]));


  });

  test("propagate children test", () {

    final expanded = ExpandableFieldState(key: "key", dataFactory: (i) => TextFieldState(key: i.toString()));

    expanded.addListener(() {
      print(expanded.value.map((e) => e.value));
    });

    expanded.value.first.value = "v";

    expect(expanded.isValid, true);

    expanded.addFactory();
    expect(expanded.isValid, false);

    expanded.value.last.value = "v2";
    expect(expanded.isValid, true);

  });

  test("listeners resources management test", () {

    final expanded = ExpandableFieldState(key: "key", dataFactory: (i) => TextFieldState(key: i.toString()));

    expect(expanded.value.first.hasListeners, true);
    //expanded.killListener(expanded.value.first);
    expect(expanded.value.first.hasListeners, false);



  });

}