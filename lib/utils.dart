

import 'dart:math';

import 'package:flutter/material.dart';

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
      children: List.generate(max(0, data.length * 2 - 1), (index) {
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
      children: List.generate(max(0, data.length * 2 - 1), (index) {
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