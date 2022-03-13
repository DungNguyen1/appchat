import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Userimagepicker extends StatefulWidget {
  Userimagepicker(this.imagePickFn);
  void Function(File pickedImage) imagePickFn;
  @override
  _UserimagepickerState createState() => _UserimagepickerState();
}

class _UserimagepickerState extends State<Userimagepicker> {
  var _pickerImage;
  void _cameraimage() async {
    var pickerImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickerImage = File(pickerImageFile!.path);
    });
    widget.imagePickFn(_pickerImage);
  }

  void _galleryiamge() async {
    var pickerImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _pickerImage = File(pickerImageFile!.path);
    });
    widget.imagePickFn(_pickerImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _pickerImage == null
            ? CircleAvatar(
                foregroundColor: Colors.black,
                radius: 40,
                backgroundImage:
                    AssetImage("assets/download.jpeg") as ImageProvider)
            : CircleAvatar(
                radius: 40, backgroundImage: FileImage(_pickerImage)),
        TextButton(
            onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                          onPressed: _cameraimage, child: Text("Camera")),
                      CupertinoActionSheetAction(
                          onPressed: _galleryiamge, child: Text("Gallery")),
                    ],
                  ),
                  barrierDismissible: true,
                  useRootNavigator: true,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image),
                Text("Add Image"),
              ],
            ))
      ],
    );
  }
}
