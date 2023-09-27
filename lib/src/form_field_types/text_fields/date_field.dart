import 'dart:math';
import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/form_field_configuration.dart';
import 'package:dynamic_forms/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




final class DateTextFieldConfiguration extends BaseTextFormFieldConfiguration {

  /// It can be [any] (Default), [future], [past]
  /// [custom] where two params [max] and [min] must be provided as datetimes by the keys [min_date] and [max_date]
  static const String KEY_PICKER_TYPE = "date_picker_type";

  final DateTime minDate;
  final DateTime maxDate;

  DateTextFieldConfiguration.custom({
    super.label,
    super.flex,
    super.hint = "01/01/2000",
    super.suffixIcon = Icons.calendar_month_rounded,
    required DateTime minDate,
    required DateTime maxDate,
  }) : minDate = minDate, maxDate = maxDate,super(
      type: AvailableTextFieldInputTypes.date,
      isObscure: false,
      formatter: DateTextFormatter(minYear: minDate.year, maxYear: maxDate.year),
  );

  DateTextFieldConfiguration.any({
    super.label,
    super.flex,
    super.hint = "01/01/2000",
    super.suffixIcon = Icons.calendar_month_rounded,
  }) :  maxDate = DateTime(3000),
        minDate = DateTime(1),
        super(
      type: AvailableTextFieldInputTypes.date,
      isObscure: false,
        formatter: DateTextFormatter(minYear: 1, maxYear: 3000),

  );

  DateTextFieldConfiguration.future({
    super.label,
    super.flex,
    super.hint = "01/01/2000",
    super.suffixIcon = Icons.calendar_month_rounded,
  }) :    maxDate = DateTime(3000),
          minDate = DateTime.now(),
  super(
      type: AvailableTextFieldInputTypes.date,
      isObscure: false,
      formatter: DateTextFormatter(minYear: DateTime.now().year, maxYear: 3000),
  );

  DateTextFieldConfiguration.past({
    super.label,
    super.flex,
    super.hint = "01/01/2000",
    super.suffixIcon = Icons.calendar_month_rounded,
  }) :  maxDate = DateTime.now(),
        minDate = DateTime(1),
        super(
        type: AvailableTextFieldInputTypes.date,
        isObscure: false,
        formatter: DateTextFormatter(minYear: 1, maxYear: DateTime.now().year),
      );


  factory DateTextFieldConfiguration.fromJSON(Map<String, dynamic> json) {
  
    var pickerType = json[KEY_PICKER_TYPE] as String?;
    late DateTime minDate, maxDate;
    switch (pickerType) {
      case "future": {
        minDate = DateTime.now();
        maxDate = DateTime(3000);
      }
      case "past": {
        minDate = DateTime(1);
        maxDate = DateTime.now();
      }
      case "custom": {
        minDate = DateTime.parse((json["min_date"] as String).replaceAll("/", "-"));
        maxDate = DateTime.parse((json["max_date"] as String).replaceAll("/", "-"));
      }
      default: {
        minDate = DateTime(1);
        maxDate = DateTime(3000);
      }
    }
    
    return DateTextFieldConfiguration.custom(
        label: json[FormFieldConfiguration.KEY_LABEL],
        flex: json[FormFieldConfiguration.KEY_FLEX],
        hint: json[BaseTextFormFieldConfiguration.HINT_KEY],
        suffixIcon: json[BaseTextFormFieldConfiguration.SUFFIX_KEY],
        minDate: minDate,
        maxDate: maxDate,
    );
  }

}

final class DateTextFieldState extends BaseTextFieldState {

  DateTextFieldState({
    required super.key,
    DateTime? initialValue,
    DateTextFieldConfiguration? configuration,
    super.isRequired,
    super.enabled,
    super.callback,
  }) : super(

      initialValue: initialValue != null ? "${initialValue.day}${initialValue.month}/${initialValue.year}" : null,
      configuration: configuration ?? DateTextFieldConfiguration.any());

  factory DateTextFieldState.fromJSON(Map<String, dynamic> json) => DateTextFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      initialValue: json[DynamicFormFieldState.KEY_INITIAL_VALUE],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED],
      configuration: DateTextFieldConfiguration.fromJSON(json)
  );

  @override
  DateTextFieldConfiguration get configuration => super.configuration as DateTextFieldConfiguration;

  @override
  MapEntry<String, DateTime?> asJsonEntry() {
    return MapEntry(key, value?.parseAsBrDate());
  }

  @override
  bool validator(String? v) {
    if (v == null) return false;
    DateTime date;
    try {
      date = v.parseAsBrDate();
    } catch (e) {
      return false;
    }

    if (date.isAfter(configuration.maxDate) || date.isBefore(configuration.minDate)) return false;
    return true;
  }

  /*
  @override
  bool validate([String invalidMsg = "Campo inválido"]) {

    if (value?.length == 8 && error != null) {
      error = null;
      return true;
    }

    if (value?.length != 8 && error == null) {
      error = invalidMsg;
      return false;
    }

    /// Check for range errors
    if (value?.length == 8 && error != null) {

      var date = value!.parseAsBrDate();
      var tooEarlyError = "Data deve ser posterior a $date";
      var tooLateError = "Data deve ser inferior a $date";

      if (date.isBefore(configuration.minDate) && error != tooEarlyError) {
        error = tooEarlyError;
      } else if (date.isAfter(configuration.maxDate) && error != tooLateError) {
        error = tooLateError;
      }
      return false;
    }

    if (error != null) error = null;
    return true;
  }

   */

}

////////////////////////////////////////////////// UTILS ////////////////////////////////////////////////


extension DateTimeParsing on String {
  DateTime parseAsBrDate() {
    final datePattern1 = RegExp(r'(\d{1,2})[/\-](\d{1,2})[/\-](\d{4})');
    final datePattern2 = RegExp(r'(\d{1,2})[/\-](\d{4})');
    final match1 = datePattern1.firstMatch(replaceAll(" ", ""));
    final match2 = datePattern2.firstMatch(replaceAll(" ", ""));

    if (match1 != null) {
      final day = int.parse(match1.group(1)!);
      final month = int.parse(match1.group(2)!);
      final year = int.parse(match1.group(3)!);
      return DateTime(year, month, day);
    } else if (match2 != null) {
      final dayOrMonth = int.parse(match2.group(1)!);
      final year = int.parse(match2.group(2)!);
      return DateTime(year, dayOrMonth, 1);
    } else {
      throw const FormatException('Invalid date format');
    }
  }
}


class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;
  final int minYear;
  final int maxYear;

  DateTextFormatter({required this.minYear, required this.maxYear});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '/');

    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String separator) {
    value = value.replaceAll(separator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      if (value[i].isDigit) {
        newString += value[i];
        if ((i == 1 || i == 3) && i != value.length - 1) {
          newString += separator;
        }
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  // Function to check if the date is within the specified range
  bool isDateInRange(String date) {
    if (date.length != 8) {
      return false; // Invalid date length
    }

    final year = int.tryParse(date.substring(4, 8));
    final month = int.tryParse(date.substring(2, 4));
    final day = int.tryParse(date.substring(0, 2));

    if (year == null || month == null || day == null) {
      return false; // Invalid date components
    }

    if (year < minYear || year > maxYear) {
      return false; // Year out of range
    }

    if (month < 1 || month > 12) {
      return false; // Month out of range
    }

    if (day < 1 || day > 31) {
      return false; // Day out of range
    }

    return true;
  }
}
