import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onboarding/LoginRegistrationModel.dart';

import 'LayoutHelper.dart';
import 'MyAppBar.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.model}) : super(key: key);
  final RegistrationModel model;
  @override
  _Profile createState() => _Profile(model);
}

class _Profile extends State<Profile> {
  final RegistrationModel model;
  File imageFile;
  _Profile(this.model);
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: MyAppBar(title: "Profile"),
        body: Column(
          children: [
            CenterHorizontal(CircleAvatar(
                radius: 60,
                backgroundImage: (imageFile == null)
                    ? NetworkImage(
                        "https://readyrefrigeration.ca/sites/default/files/styles/headshot/adaptive-image/public/nobody.jpg")
                    : FileImage(imageFile))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text("Remove Image"),
                  onPressed: () {
                    setState(() {
                      imageFile = null;
                    });
                  },
                ),
                RaisedButton(
                  child: Text("change Image"),
                  onPressed: () {
                    _showPicker(context);
                  },
                )
              ],
            ),
            TextColumn("Name", model.name),
            TextColumn("Email", model.email),
          ],
        )));
  }

  final _picker = ImagePicker();
  _pickImage(int option) async {
    PickedFile pickedFile = await _picker.getImage(
        source: (option == 1) ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 80);
    _cropImage(pickedFile.path);
  }

  /// Crop Image
  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 500,
      maxHeight: 500,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      compressQuality: 80,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _pickImage(1);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _pickImage(2);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
