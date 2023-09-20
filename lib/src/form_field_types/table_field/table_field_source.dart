
import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/form_controller.dart';
import 'package:dynamic_forms/src/form_field_configuration.dart';
import 'package:dynamic_forms/src/form_field_types/table_field/table_components.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class TableFieldGridSource extends DataGridSource {

  final TableFieldState state;

  TableFieldGridSource(this.state) {
    state.addListener(() => notifyDataSourceListeners());
  }

  @override
  List<DataGridRow> get rows => state.value.map(_formToRow).toList();

  DataGridRow _formToRow(FormModel e) {
    return DataGridRow(cells: e.allFields.map((e) => DataGridCell<DynamicFormFieldState>(
        columnName: e.configuration.label ?? e.key,
        value: e
    )).toList());
  }

  List<StackedHeaderRow> headers() {
    return [];
  }


  /// /////////////////////////////////////////////////////////////// Editing //////////////////////////////////////////////////////////////////////////////


  dynamic _inputValue; // A variable to hold the current edit value

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {

    final dynamic oldValue = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) =>
    dataGridCell.columnName == column.columnName)?.value ?? '';

    if (_inputValue == null || oldValue == _inputValue) return;

    var rowForm = state.value[rowColumnIndex.rowIndex];
    var cellField = rowForm.findByKey(column.columnName);

    if (cellField.validator(_inputValue)) {
      cellField.value = _inputValue;
      rows[rowColumnIndex.rowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<DynamicFormFieldState>(
          columnName: column.columnName,
          value: cellField
      );
    }

    notifyDataSourceListeners();
    //notifyListeners();
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {

    _inputValue = null;
    var field = state.value[rowColumnIndex.rowIndex].findByKey(column.columnName);
    var fieldConfiguration = field.configuration;


    final String displayText = dataGridRow
        .getCells()
        .firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value?.toString() ?? '';


    if (field.configuration.formType == FormFieldType.textField) {
      fieldConfiguration = fieldConfiguration as BaseTextFormFieldConfiguration;

      return Container(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          autofocus: true,
          onTapOutside: (_) => submitCell(),
          onChanged: (String value) => _inputValue = value,
          inputFormatters: fieldConfiguration.formatter != null ? [fieldConfiguration.formatter!] : null,
          decoration: InputDecoration(
            hintText: displayText,

          ),
        ),
      );
    }

    return const SizedBox();

  }


  /// //////////////////////////////////////////////////////// Build Related Methods ////////////////////////////////////////////////////////////////////////

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells()
        .map<Widget>((e) => DefaultTableCell(cell: e as DataGridCell<DynamicFormFieldState>))
        .toList());
  }


}

