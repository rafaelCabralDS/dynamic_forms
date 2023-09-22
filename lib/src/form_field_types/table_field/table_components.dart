import 'package:dynamic_forms/src/components/dynamic_form_theme.dart';
import 'package:dynamic_forms/src/field_state.dart';
import 'package:dynamic_forms/src/form_field_types/table_field/table_field_source.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';



class DefaultTableCell extends StatelessWidget {

  final DataGridCell<DynamicFormFieldState> cell;
  const DefaultTableCell({super.key, required this.cell});

  @override
  Widget build(BuildContext context) {

    var style = DynamicFormTheme.of(context);

    return Center(
      child: Text(
        cell.value?.value ?? cell.columnName,
        style: cell.value != null
            ? style.tableFieldStyle.filledCellStyle
            : style.tableFieldStyle.emptyCellTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}



class TableFieldStyle {

  final TextStyle? filledCellStyle;
  final TextStyle? emptyCellTextStyle;
  final TextStyle? headerTextStyle;

  final Color? headerColor;
  final Widget Function()? footerBuilder;
  final double? footerHeight;

  const TableFieldStyle({
    this.filledCellStyle,
    this.emptyCellTextStyle,
    this.headerColor,
    this.headerTextStyle,
    this.footerBuilder,
    this.footerHeight,
  });


}



class TableFieldBuilder extends StatefulWidget {

  final TableFieldState state;

  const TableFieldBuilder({super.key, required this.state});

  @override
  State<TableFieldBuilder> createState() => _TableFieldBuilderState();
}

class _TableFieldBuilderState extends State<TableFieldBuilder> {


  late final TableFieldGridSource _source;

  @override
  void initState() {
    _source = TableFieldGridSource(widget.state);
    super.initState();
  }


  Widget _buildFooter() => Builder(
    builder: (context) {
      return InkWell(
          onTap: () => widget.state.addFactory(),
          child: DynamicFormTheme.of(context).tableFieldStyle.footerBuilder?.call() ?? Container(
            color: Colors.grey[100],
            child: Center(child: Text("Adicionar+", style: Theme.of(context).textTheme.labelLarge)),
          )
      );
    }
  );

  @override
  Widget build(BuildContext context) {

    var style = DynamicFormTheme.of(context);

    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: style.tableFieldStyle.headerColor,
        gridLineStrokeWidth: 0,
        frozenPaneLineWidth: 0,
        frozenPaneElevation: 0,

        //headerHoverColor: ,

      ),
      child: SfDataGrid(
        source: _source,
        //shrinkWrapColumns: true,
        shrinkWrapRows: true,
        columnWidthMode: ColumnWidthMode.fill,
        editingGestureType: EditingGestureType.tap,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.cell,
        footer: _buildFooter(),
        footerHeight: style.tableFieldStyle.footerHeight ?? 49.9,

        allowEditing: true,
        //headerGridLinesVisibility:GridLinesVisibility.vertical,

        stackedHeaderRows: [],

        columns: widget.state.sample.allFields.map((e) => GridColumn(
            columnName: e.key,
            label: Center(
                child: Text(
                  e.configuration.label ?? e.key,
                  style: style.tableFieldStyle.headerTextStyle,
                ))
        )).toList(),
      ),
    );

  }
}
