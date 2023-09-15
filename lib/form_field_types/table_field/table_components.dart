import 'package:dynamic_forms/field_state.dart';
import 'package:dynamic_forms/form_field_types/table_field/table_field_source.dart';
import 'package:dynamic_forms/form_field_types/table_field/table_field_state.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

class BuildTableHeader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class DefaultTableCell extends StatelessWidget {

  final DataGridCell cell;
  const DefaultTableCell({super.key, required this.cell});

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.labelSmall;
    return Center(
      child: Text(
        cell.value ?? cell.columnName,
        style: cell.value != null ? textStyle : textStyle!.copyWith(color: Colors.grey[400]),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
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
          child: Container(
            color: Colors.grey[100],
            child: Center(child: Text("Adicionar +", style: Theme.of(context).textTheme.labelLarge)),
          )
      );
    }
  );

  @override
  Widget build(BuildContext context) {

    return SfDataGridTheme(
      data: SfDataGridThemeData(),
      child: SfDataGrid(
        source: _source,
        columnWidthMode: ColumnWidthMode.fill,
        editingGestureType: EditingGestureType.tap,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.cell,
        footer: _buildFooter(),
        footerFrozenRowsCount: 1,
        allowEditing: true,
        //headerGridLinesVisibility:GridLinesVisibility.vertical,


        columns: widget.state.sample.allFields.map((e) => GridColumn(
            columnName: e.key,
            label: Center(child: Text(e.configuration.label ?? e.key))
        )).toList(),
      ),
    );

  }
}
