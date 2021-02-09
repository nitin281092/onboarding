import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:onboarding/Registration.dart';
import 'package:provider/provider.dart';

import 'AppThemeMode.dart';
import 'MyAppBar.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool isdarkmodeon = false;
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<AppThemeMode>(context);
    return Scaffold(
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
                      onPressed: () =>
                          {if (_formKey.currentState.validate()) {}},
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
}
