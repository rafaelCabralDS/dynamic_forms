
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:dynamic_forms/field_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

enum SupportedFiles {
  pdf(["pdf"]),
  image(["jpg", "png", "jpeg"]),
  doc(["docx"]),
  sheet(["csv", "xlsx"]);

  final List<String> extensions;

  const SupportedFiles(this.extensions);

  static SupportedFiles fromExtension(String ext) {
    for (var type in SupportedFiles.values) {
      if (type.extensions.contains(ext) || type.name == ext) {
        return type;
      }
    }
    throw "Unsupported file type";
  }

  static List<String> asExtensionList(List<SupportedFiles> files) => files.expand((element) => element.extensions).toList();

  static List<SupportedFiles> fromExtensions(List<String> extensions) => extensions.map((e) => fromExtension(e)).toList();

}

final class FileFieldConfiguration extends FormFieldConfiguration {

  static const String KEY_SUPPORTED_FILES = "supported_files";
  static const String KEY_MULTIPLE_FILES = "multiple";
  static const String KEY_LIMIT = "limit";


  final bool multiplePicks;
  final int limit;

  const FileFieldConfiguration({
    super.flex,
    super.label,
    required this.supportedInputFiles,
    this.multiplePicks = true,
    this.limit = 1000,
  }) : super(
    formType: FormFieldType.file,
  );

  const FileFieldConfiguration.any({
    String? label,
    int? flex,
    bool? multiplePicks = true,
    int? limit
  }) : this(
      flex: flex,
      label: label,
      supportedInputFiles: SupportedFiles.values,
      limit: limit ?? 1000
  );


  factory FileFieldConfiguration.fromJSON(Map<String,dynamic> json) => FileFieldConfiguration(
      supportedInputFiles: SupportedFiles.fromExtensions(json[KEY_SUPPORTED_FILES]),
      flex: json[FormFieldConfiguration.KEY_FLEX],
      label: json[FormFieldConfiguration.KEY_LABEL],
      multiplePicks: json[KEY_MULTIPLE_FILES],
      limit: json[KEY_LIMIT]
  );

  final List<SupportedFiles> supportedInputFiles;
}

final class FilePickerFieldState extends DynamicFormFieldState<List<PlatformFile>> {

  FilePickerFieldState({
    required super.key,
    required super.configuration,
    super.isRequired,
  }) : super(
    initialValue: []
  );

  factory FilePickerFieldState.fromJSON(Map<String, dynamic> json) => FilePickerFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED] ?? true,
      configuration: FileFieldConfiguration.fromJSON(json)
  );

  @override
  List<PlatformFile> get value => super.value!;

  bool get isFull => value.length == configuration.limit;

  @override
  bool validator(List<PlatformFile>? v) => v != null;

  @override
  FileFieldConfiguration get configuration => super.configuration as FileFieldConfiguration;

  @override
  void reset() {
    value.clear();
    error = null;
  }

  Future<void> pick() async {
    assert (value.length < (configuration.limit ?? 1000), "Too many files have being picker already");
    try {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: SupportedFiles.asExtensionList(configuration.supportedInputFiles),
          allowMultiple: configuration.multiplePicks,
      );
      if (result == null) return;

      value.addAll(result.files);
      notifyListeners();

    } catch (e) {
      error = "nonNullErrorValue";
    }

  }

  void remove(PlatformFile e) {
    value.remove(e);
    notifyListeners();
  }

}

//////////////////////////////////////////////////////////////////////////////////////////

class DefaultFilePickerBuilder extends StatefulWidget {

  final FilePickerFieldState state;
  final void Function(BuildContext) onError;
  final FileFormFieldBuilder? fileFieldBuilder;

  const DefaultFilePickerBuilder({super.key,
    required this.state,
    this.onError = _DefaultFilePickerBuilderState._defaultErrorCallback,
    this.fileFieldBuilder,
  });

  @override
  State<DefaultFilePickerBuilder> createState() => _DefaultFilePickerBuilderState();
}

class _DefaultFilePickerBuilderState extends State<DefaultFilePickerBuilder> {

  static void _defaultErrorCallback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Algo deu errado"))
    );
  }

  @override
  void initState() {

    widget.state.addListener(() {
      if (widget.state.error != null) {
          widget.onError(context);
      }
    });

    super.initState();
  }

  Widget _buildPickPreview(PlatformFile file) {

    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: Column(
        children: [
          Container(
            width: 50.0,
            height: 50.0 * 5/4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Builder(
              builder: (context) {

                /*
                if (SupportedFiles.image.extensions.contains(file.extension)) {
                  return Image(image: MemoryImage(file.bytes));
                }

                 */

                return const Icon(Icons.description_rounded, color: Colors.grey);
              }
            ),
          ),

          const SizedBox(height: 5),
          Expanded(child: Text(file.name, overflow: TextOverflow.ellipsis,)),
        ],
      ),
    );
    
  }

  Widget _buildAddFile() => SizedBox(
    width: 100.0,
    height: 100.0,
    child: Column(
      children: [
        Container(
          width: 50.0,
          height: 50.0 * 5/4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Icon(Icons.add_rounded, color: Colors.grey),
        ),

        const SizedBox(height: 5),
        Expanded(child: Text("Adicionar", overflow: TextOverflow.ellipsis,)),
      ],
    ),
  );
  
  @override
  Widget build(BuildContext context) {

    if (widget.fileFieldBuilder != null) {
      return widget.fileFieldBuilder!(widget.state);
    }

    return InkWell(
      onTap: () => widget.state.pick(),
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey[100],
          border: Border.all(
            color: widget.state.error != null ? Colors.redAccent : Colors.transparent,
            width: 2
          )
        ),
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Builder(
              builder: (context) {

                if (widget.state.isValid) {
                  return Row(
                    children: [
                      SeparatedRow(
                        data: widget.state.value,
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10.0),
                        itemBuilder: (_, i) => SizedBox.square(
                            child: _buildPickPreview(widget.state.value[i])
                        )),
                        SizedBox(width: 10.0),
                        _buildAddFile(),

                    ],
                  );
                }


                return Text(widget.state.configuration.label ?? "Selecionar arquivos", style: Theme.of(context).textTheme.headlineSmall);
              }
            )
        ),
      ),
    );

  }
}

