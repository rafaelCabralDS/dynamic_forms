import 'package:dynamic_forms/form_controller.dart';
import 'package:dynamic_forms/form_field_builder.dart';
import 'package:dynamic_forms/utils.dart';
import 'package:flutter/material.dart' hide FormFieldBuilder, FormFieldState;

import 'field_state.dart';

class DynamicForm extends StatefulWidget {

  final FormController controller;
  final TextFormFieldBuilder? textFieldBuilder;

  /// A map that overrides the default fields builders for specific field
  /// by the key value
  final Map<String, FormFieldBuilder>? customFieldsBuilder;

  final double runningSpacing;
  final double verticalSpacing;

  /// How the title and subtitle will be built
  final FormHeaderBuilder? formHeader;

  const DynamicForm({super.key,
    required this.controller,
    this.textFieldBuilder,
    this.runningSpacing = 10.0,
    this.verticalSpacing = 10.0,
    this.formHeader,
    this.customFieldsBuilder,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();

}

class _DynamicFormState extends State<DynamicForm> {

  Widget _buildRow(List<DynamicFormFieldState> fields) => SeparatedRow(
    data: fields,
    itemBuilder: (_,i) => Expanded(
      flex: fields[i].configuration.flex,
      child: Builder(
        builder: (context) {

          if (widget.customFieldsBuilder?.containsKey(fields[i].key) ?? false) {
            return widget.customFieldsBuilder![fields[i].key]!(fields[i]);
          }

          return BuildFormField(fields[i],
              textFieldBuilder: widget.textFieldBuilder
          );
        }
      ),
    ),
    separatorBuilder: (_,i) => SizedBox(width: widget.runningSpacing),
  );


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        
          widget.formHeader?.call(widget.controller.form) ?? defaultFormHeaderBuilder(widget.controller.form),

        SeparatedColumn(
          data: widget.controller.fields,
          itemBuilder: (_,i) => _buildRow(widget.controller.fields[i]),
          separatorBuilder: (_,i) => SizedBox(height: widget.verticalSpacing),
        ),
      ],
    );
  }
}

Widget defaultFormHeaderBuilder(FormModel model) => _DefaultFormHeaderBuilder(form: model);

class _DefaultFormHeaderBuilder extends StatelessWidget {

  final FormModel form;
  const _DefaultFormHeaderBuilder({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (form.title != null)
          Text(form.title!, style: Theme.of(context).textTheme.headlineMedium),

        if (form.desc != null)
          Text(form.desc!, style: Theme.of(context).textTheme.labelMedium),

        Divider(
          height: 30.0,
        )
      ],
    );
  }
}

