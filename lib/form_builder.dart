import 'package:dynamic_forms/form_controller.dart';
import 'package:dynamic_forms/form_field_builder.dart';
import 'package:dynamic_forms/utils.dart';
import 'package:flutter/material.dart' hide FormFieldBuilder, FormFieldState;

import 'field_state.dart';

class DynamicForm extends StatefulWidget {

  final FormController controller;
  final TextFormFieldBuilder? textFieldBuilder;
  final double runningSpacing;
  final double verticalSpacing;

  const DynamicForm({super.key,
    required this.controller,
    this.textFieldBuilder,
    this.runningSpacing = 20.0,
    this.verticalSpacing = 20.0,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();

}

class _DynamicFormState extends State<DynamicForm> {

  Widget _buildRow(List<FormFieldState> fields) => SeparatedRow(
    data: fields,
    itemBuilder: (_,i) => BuildFormField(fields[i],
        textFieldBuilder: widget.textFieldBuilder
    ),
    separatorBuilder: (_,i) => SizedBox(width: widget.runningSpacing),
  );


  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      data: widget.controller.fields,
      itemBuilder: (_,i) => _buildRow(widget.controller.fields[i]),
      separatorBuilder: (_,i) => SizedBox(height: widget.verticalSpacing),
    );
  }
}
