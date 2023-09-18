

import 'dart:math' as math;

import 'package:dynamic_forms/form_field_types/text_fields/text_field_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeparatedRow extends StatelessWidget {
  final List data;
  final IndexedWidgetBuilder itemBuilder, separatorBuilder;

  const SeparatedRow(
      {Key? key,
        required this.data,
        required this.separatorBuilder,
        required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(math.max(0, data.length * 2 - 1), (index) {
        final int itemIndex = index ~/ 2;
        if (index.isEven) {
          return itemBuilder(context, itemIndex);
        }
        return separatorBuilder(context, itemIndex);
      }),
    );
  }
}

class SeparatedColumn extends StatelessWidget {
  final List data;
  final IndexedWidgetBuilder itemBuilder, separatorBuilder;

  const SeparatedColumn(
      {Key? key,
        required this.data,
        required this.separatorBuilder,
        required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(math.max(0, data.length * 2 - 1), (index) {
        final int itemIndex = index ~/ 2;
        if (index.isEven) {
          return itemBuilder(context, itemIndex);
        }
        return separatorBuilder(context, itemIndex);
      }),
    );
  }
}

extension ListExtension<E> on List<E> {
  List<E> removeAll(Iterable<E> allToRemove) {
    for (var element in allToRemove) {
      remove(element);
    }
    return this;
  }

  List<E> getDuplicates() {
    List<E> dupes = List.from(this);
    dupes.removeAll(toSet().toList());
    return dupes;
  }
}

extension StringExtension on String {

  bool get isDigit => int.tryParse(this) != null;

}

extension TextInputTypeExtension on String? {

  TextInputFormatter? get asFormatter {

    if (this == AvailableTextFieldInputTypes.integer.key) {
      return FilteringTextInputFormatter.digitsOnly;
    }

    if (this == AvailableTextFieldInputTypes.decimal.key) {
      return const DecimalTextInputFormatter(decimalRange: 2);
    }

    return null;
  }

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => this == null || this!.isEmpty;

}


class DecimalTextInputFormatter extends TextInputFormatter {
  const DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}