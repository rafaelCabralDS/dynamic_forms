import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("cellphone number test", () {

    final field = PhoneFieldState(key: "key");

    field.value = "(42) 99936-3251";
    expect(field.isValid, true);

  });

  test("fixed phone number test", () {

    final field = PhoneFieldState(key: "key");

    field.value = "(42) 09993-321";
    expect(field.isValid, true);

  });

  test("invalid phone number test", () {

    final field = PhoneFieldState(key: "key");

    field.value = "(42) 9993-32";
    expect(field.isValid, false);

  });


}