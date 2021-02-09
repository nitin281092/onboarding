import 'dart:convert';
import 'package:onboarding/ResposeModels.dart';
import 'package:flutter/material.dart';

class Helper {
  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showSnakbar(String error, BuildContext context,
      GlobalKey<ScaffoldState> _scaffoldKey) {
    var errormodel = Error.fromJson(jsonDecode(error));
    var errors = errormodel.email + errormodel.password + errormodel.error;
    String er = errors.join(",");
    final snackBar = SnackBar(
      content: Text(er),
    );
    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
