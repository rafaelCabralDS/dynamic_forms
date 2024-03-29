
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import 'package:mime_type/mime_type.dart';
export 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:dynamic_forms/dynamic_forms.dart';


///   A class that can describe both a file that came from local storage [data], downloaded from the db [data]
/// or just as a promise of a file based on the [path].
///   It also holds optional metadata information
sealed class FileModel with EquatableMixin {


  const FileModel._({
    this.data,
    this.path,
    this.metadata,
    required this.size,
    required this.name,
    this.extension,
  });

  final Uint8List? data;
  final String? path;
  final Map<String,String>? metadata;
  String? get contentType => mime(name);

  final int size;
  final String name;
  final String? extension;

  PlatformFile get asPlatformFile => PlatformFile(
    name: name,
    size: size,
    bytes: data,
  );

  /// It can get either a url or a PlatformFile as json payload
  static FileModel? tryFile(dynamic file) {
    if (file is String) return UrlFile(url: file);
    if (file is BytesFile) return file;
    if (file is UrlFile) return file;
    if (file is PlatformFile) {
      return BytesFile(bytes: file.bytes, name: file.name, size: file.size);
    }
    return null;
  }

  @override
  List<Object?> get props => [data, path, size, name, contentType];

  String toJSON() {
    assert(this is UrlFile, "You are trying to parse a file that is not an instance of "
        "UrlFile as a json entry");
    return path!;
  }

  @override
  String toString() => "$runtimeType(name: $name, size: $size, path $path, extension: $extension, metadata: $metadata";

}

class BytesFile extends FileModel {

  const BytesFile({
    required Uint8List? bytes,
    required super.name,
    required super.size,
    super.extension,
    super.metadata,
  }) : super._(path: null, data: bytes);

}

class UrlFile extends FileModel {

  const UrlFile({
    required String url,
    super.extension,
    String? name,
    int? size,
    super.metadata,
  }) : super._(path: url, data: null,  size: size ?? -1,
      name: name ?? url
  );

  @override
  String get path => super.path as String;

  UrlFile copyWith({
    int? size,
    String? url,
    String? extension,
    Map<String,String>? customMetadata,
    String? name,
  }) => UrlFile(
      url: url ?? path,
      extension: extension ?? this.extension,
      name: name ?? this.name,
      metadata:  metadata ?? metadata,
      size: size ?? this.size
  );


}

/// A file that failed when downloading the data. It can represent a corrupted file saved on the db for example,
/// or just a read error
class CorruptedFile extends FileModel{
  const CorruptedFile({
    super.path,
    super.extension,
    required super.name,
    super.metadata,
  }) : super._(size: -2, data: null);

}

/////////////////////////////////////////////////////////////////////////////////////////////////////

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

final class FilePickerFieldState extends DynamicFormFieldState<List<FileModel>> {

  FilePickerFieldState({
    required super.key,
    required super.configuration,
    super.isRequired,
    super.callback,
    List<FileModel> initialValue = const [],
    super.jsonEntryMapper,
  }) :super(initialValue: List.from(initialValue));

  factory FilePickerFieldState.fromJSON(Map<String, dynamic> json) => FilePickerFieldState(
      key: json[DynamicFormFieldState.KEY_KEY],
      isRequired: json[DynamicFormFieldState.KEY_REQUIRED] ?? true,
      configuration: FileFieldConfiguration.fromJSON(json)
  );

  @override
  List<FileModel> get value => super.value!;

  bool get isFull => value.length == configuration.limit;

  @override
  bool validator(List<FileModel>? v) => v != null;

  @override
  FileFieldConfiguration get configuration => super.configuration as FileFieldConfiguration;

  @override
  void reset() {
    value.clear();
    error = null;
  }

  Future<void> pick() async {
    assert (value.length < (configuration.limit), "Too many files have being picker already");
    try {

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          withData: true, // save in the memory
          allowedExtensions: SupportedFiles.asExtensionList(configuration.supportedInputFiles),
          allowMultiple: configuration.multiplePicks,
      );

      if (result == null) return;


      value.addAll(result.files.map((e) => BytesFile(
        bytes: e.bytes,
        name: e.name,
        extension: e.extension,
        size: e.size,
      )).toList());
      notifyListeners();

    } catch (e) {
      print(e);
      error = "nonNullErrorValue";
    }

  }

  void remove(FileModel e) {
    value.remove(e);
    notifyListeners();
  }

}

//////////////////////////////////////////////////////////////////////////////////////////

typedef FileFormFieldBuilder = Widget Function(FilePickerFieldState field);

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

  Widget _buildPickPreview(FileModel file) {

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

                switch (file) {

                  case BytesFile():
                    return const Icon(Icons.description_rounded, color: Colors.grey);
                  case UrlFile():
                  return const Icon(Icons.alternate_email, color: Colors.grey);
                  case CorruptedFile():
                  return const Icon(Icons.close, color: Colors.grey);
                }

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
          child: const Icon(Icons.add_rounded, color: Colors.grey),
        ),

        const SizedBox(height: 5),
        const Expanded(child: Text("Adicionar", overflow: TextOverflow.ellipsis,)),
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
                        const SizedBox(width: 10.0),
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

////////////////////////////////////////////////////////////////////////////////////////////////////////

final class ThumbnailConfiguration extends FormFieldConfiguration {
  const ThumbnailConfiguration() : super(formType: FormFieldType.file);
}

final class ThumbnailPickerFieldState extends DynamicFormFieldState<FileModel> {

  ThumbnailPickerFieldState({
    required super.key,
    super.isRequired,
    super.callback,
    super.initialValue,
    super.jsonEntryMapper,
  }) :super(configuration: const ThumbnailConfiguration());


  @override
  void reset() {
    value = null;
    error = null;
  }

  Future<void> pick() async {

    try {

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: true, // save in the memory
        allowedExtensions: SupportedFiles.image.extensions,
        allowMultiple: false,
      );

      if (result == null) return;
      var e = result.files.first;
      value = BytesFile(
        bytes: e.bytes,
        name: e.name,
        extension: e.extension,
        size: e.size,
      );
      notifyListeners();

    } catch (e) {
      error = "nonNullErrorValue";
    }

  }

  @override
  bool validator(FileModel? v) => true;

}



class ImageFileStateBuilder extends StatelessWidget {

  final ThumbnailPickerFieldState state;
  final Widget emptyBuilder;
  final Widget loadingBuilder;
  final Widget errorBuilder;

  const ImageFileStateBuilder({super.key,
    required this.state,
    this.emptyBuilder = const Icon(Icons.camera_enhance),
    this.loadingBuilder = const CircularProgressIndicator(),
    this.errorBuilder = const Icon(Icons.error_outline),
  });

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: state,
        builder: (context, child) {
          var value = state.value;

          return switch (value) {
            null => emptyBuilder,
            BytesFile() => Image.memory(value.data!),
            UrlFile() => Image.network(value.path,
              errorBuilder: (_, __, ___) => errorBuilder,
            ),
            CorruptedFile() => const SizedBox.shrink(),
          };
        }
    );
  }
}


