import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onboarding/Helper.dart';
import 'package:onboarding/ResposeModels.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'LayoutHelper.dart';
import 'MyAppBar.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  Profile({Key key, this.model}) : super(key: key);
  final User model;
  @override
  _Profile createState() => _Profile(model);
}

class _Profile extends State<Profile> {
  final User model;
  File imageFile;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _Profile(this.model);
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: MyAppBar(title: "Profile"),
        key: _scaffoldKey,
        body: Column(
          children: [
            CenterHorizontal(CircleAvatar(
                radius: 60,
                backgroundImage: (model.image == null)
                    ? NetworkImage(
                        "https://readyrefrigeration.ca/sites/default/files/styles/headshot/adaptive-image/public/nobody.jpg")
                    : NetworkImage("https://onbording.gointens.in/public/" +
                        model.image))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text("Remove Image"),
                  onPressed: () {
                    Helper.showLoaderDialog(context);
                    _removeImage(context);
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
  _pickImage(int option, BuildContext context) async {
    PickedFile pickedFile = await _picker.getImage(
        source: (option == 1) ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 80);
    _cropImage(pickedFile.path, context);
  }

  /// Crop Image
  _cropImage(filePath, BuildContext context) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 500,
      maxHeight: 500,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      compressQuality: 80,
    );
    if (croppedImage != null) {
      Helper.showLoaderDialog(context);
      _uploadImage(croppedImage, context);
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
                        _pickImage(1, context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _pickImage(2, context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _uploadImage(File _image, BuildContext context) async {
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    // get file length
    var length = await _image.length();
    var request = new http.MultipartRequest(
        "POST", Uri.parse("https://onbording.gointens.in/api/UploadImage"));
    request.fields["id"] = model.id.toString();
    var file = new http.MultipartFile("image", stream, length,
        filename: basename(_image.path));
    request.files.add(file);
    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      if (response.statusCode < 299) {
        User user = User.fromJson(jsonDecode(value));
        setState(() {
          model.image = user.image;
        });
        Navigator.pop(context);
      } else {
        Helper.showSnakbar(value, context, _scaffoldKey);
      }
    });
  }

  void _removeImage(BuildContext context) async {
    final response = await http.post(
      Uri.https('onbording.gointens.in', 'api/RemoveImage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(model),
    );
    if (response.statusCode < 299) {
      User user = User.fromJson(jsonDecode(response.body));
      setState(() {
        model.image = user.image;
      });
      Navigator.pop(context);
    } else {
      Helper.showSnakbar(response.body, context, _scaffoldKey);
    }
  }
}
