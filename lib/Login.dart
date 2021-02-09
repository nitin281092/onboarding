import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:onboarding/Helper.dart';
import 'package:onboarding/LoginRegistrationModel.dart';
import 'package:onboarding/Registration.dart';
import 'package:provider/provider.dart';

import 'AppThemeMode.dart';
import 'MyAppBar.dart';
import 'package:http/http.dart' as http;

import 'Profile.dart';
import 'ResposeModels.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool isdarkmodeon = false;
  bool _showPassword = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginModel model = new LoginModel();
  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<AppThemeMode>(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(title: "Login"),
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Enter your Email',
                        labelText: 'Email',
                      ),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "email is required"),
                        EmailValidator(errorText: "enter a valid email address")
                      ]),
                      onChanged: (val) {
                        model.email = val;
                      },
                    )),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      obscureText: !this._showPassword,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'password is required'),
                        MinLengthValidator(8,
                            errorText:
                                'password must be at least 8 digits long')
                      ]),
                      onChanged: (val) {
                        model.password = val;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.security),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: this._showPassword
                                ? (darkTheme.getTheme()
                                    ? Colors.greenAccent
                                    : Colors.blue)
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(
                                () => this._showPassword = !this._showPassword);
                          },
                        ),
                        hintText: 'Your Password',
                        labelText: 'Password',
                      ),
                    )),
                new Container(
                    padding: EdgeInsets.only(top: 20),
                    child: new RaisedButton(
                      child: Text('Login'),
                      onPressed: () => {
                        Helper.showLoaderDialog(context),
                        if (_formKey.currentState.validate())
                          {loginRequest(context)}
                        else
                          {Navigator.pop(context)}
                      },
                    )),
                new Container(
                    padding: EdgeInsets.only(top: 5),
                    child: new FlatButton(
                      child: Text('New User? Registration'),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Registration()),
                        )
                      },
                    )),
              ],
            )));
  }

  loginRequest(BuildContext context) async {
    final response = await http.post(
      Uri.https('onbording.gointens.in', 'api/Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(model),
    );
    if (response.statusCode < 299) {
      User user = User.fromJson(jsonDecode(response.body));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Profile(model: user)),
          (route) => false);
    } else {
      Helper.showSnakbar(response.body, context, _scaffoldKey);
    }
  }
}
