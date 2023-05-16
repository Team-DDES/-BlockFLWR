import 'dart:async';
import 'dart:html';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';

class FilePathBox extends StatefulWidget {
  final BuildContext context;
  final String text;
  FilePathBox({required this.context, required this.text});

  @override
  FilePathBoxState createState() => FilePathBoxState();

}

class FilePathBoxState extends State<FilePathBox> {
  String selectedPath = '';
  var pathBoxText;
  var pathBoxSize;
  Future<void> pickPath() async {
    //TODO 웹에서 path 작동하도록
    if(kIsWeb){
      final completer = Completer<FileUploadInputElement>();
      final FileUploadInputElement uploadInput = FileUploadInputElement()
      ..accept = ''
      ..multiple = false
      ..click();
      uploadInput.onChange.listen((event) {
        completer.complete(uploadInput);
      });

      await completer.future;
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);

      await reader.onLoad.first;
;
      setState(() {
        selectedPath = file.name;
      });
    }else{
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        print("Result path :: " + result.files.single.path!);
        setState(() {
          selectedPath = result.files.single.path!;
        });
      }
    }
  }

  String getSelectedFilePath() {
    return selectedPath;
  }

  void setPathBoxText(String text){
    pathBoxText = text;
  }

  void setPathBoxSize(Size size){
    pathBoxSize = size;
  }

  @override
  Widget build(BuildContext context) {
    print("selected Path :: " + selectedPath);
    pathBoxText = (selectedPath == '') ? widget.text : selectedPath;
    print("pathBox :: " + pathBoxText);
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
            StyleResources.pagerBtnCallback),
      ),
      onPressed: pickPath,
      child: Container(
        alignment: Alignment.center,
        width: pathBoxSize != null ? pathBoxSize.width : 300,
        height: pathBoxSize != null ? pathBoxSize.height : 140,
        child: selectedPath == '' ? TextUtils.defaultTextWithSize(pathBoxText, 15)
            : TextUtils.defaultTextWithSize(selectedPath, 15),
      ),
    );
  }
}