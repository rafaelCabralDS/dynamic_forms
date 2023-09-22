import 'package:dynamic_forms/src/form_field_types/text_fields/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


// Import the extension and function you want to test


void main() {
  group('DateTimeParsing extension', () {
    test('Parsing "day/month/year" format', () {
      const date1 = '5/9/2023';
      final dateTime1 = date1.parseAsBrDate();

      expect(dateTime1, equals(DateTime(2023, 9, 5)));
    });

    test('Parsing "day-month-year" format', () {
      const date2 = '1-2-2023';
      final dateTime2 = date2.parseAsBrDate();

      expect(dateTime2, equals(DateTime(2023, 2, 1)));
    });

    test('Parsing "day/month/year" format but sparced', () {
      const date1 = '  5/ 9/  2023';
      final dateTime1 = date1.parseAsBrDate();

      expect(dateTime1, equals(DateTime(2023, 9, 5)));
    });


    test('Invalid date format should throw FormatException', () {
      const invalidDate = 'invalid-date';

      expect(() => invalidDate.parseAsBrDate(), throwsFormatException);
    });
  });

  /*
  group('DateTextFormatter', () {
    late final DateTextFormatter formatter;

    setUp(() {
      formatter = DateTextFormatter(minYear: 1900, maxYear: 2100);
    });

    test('Formatting and restricting date', () {
      const date1 = '32/13/2023'; // Invalid day and month
      const date2 = '31/12/2023'; // Valid date
      const date3 = '01/01/2101'; // Year out of range

      // Apply formatter to the input strings
      final formattedDate1 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: date1),
      );
      final formattedDate2 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: date2),
      );
      final formattedDate3 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: date3),
      );

      // Verify that the formatted dates match the expected results
      expect(formattedDate1.text, '31/12/2023'); // Day and month corrected
      expect(formattedDate2.text, '31/12/2023'); // Unchanged valid date
      expect(formattedDate3.text, ''); // Empty string due to year out of range

      // Verify the cursor position for each formatted date
      expect(formattedDate1.selection, TextSelection.collapsed(offset: 10));
      expect(formattedDate2.selection, const TextSelection.collapsed(offset: 10));
      expect(formattedDate3.selection, TextSelection.collapsed(offset: 0));
    });
  });

   */

  test("date validator", () {


    final DateTextFieldState state = DateTextFieldState(key: "key");
    state.value = "22/11/2000";

    var parsedDate = state.value!.parseAsBrDate();

    expect(parsedDate.isAtSameMomentAs(DateTime(2000, 11, 22)), true);

    expect(state.validate(), true);

  });


}




