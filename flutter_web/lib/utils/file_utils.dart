import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/utils/text_utils.dart';

class FilePathBox extends StatefulWidget {
  final BuildContext context;
  FilePathBox({required this.context});

  @override
  FilePathBoxState createState() => FilePathBoxState();

}

class FilePathBoxState extends State<FilePathBox> {
  String selectedPath = '';

  Future<void> pickPath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedPath = result.files.single.path!;
      });
    }
  }

  String getSelectedFilePath() {
    return selectedPath;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: pickPath,
      child: Container(
        width: 400,
        height: 140,
        child: selectedPath == null? TextUtils.defaultTextWithSize('Insert description of model here...', 15)
            : TextUtils.defaultTextWithSize(selectedPath, 15),
      ),
    );
  }
}