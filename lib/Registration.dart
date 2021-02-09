import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:onboarding/AppThemeMode.dart';
import 'package:onboarding/LoginRegistrationModel.dart';
import 'package:onboarding/MyAppBar.dart';
import 'package:onboarding/Profile.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  RegistrationModel model = new RegistrationModel();
  bool isdarkmodeon = false;
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<AppThemeMode>(context);
    return Scaffold(
        appBar: MyAppBar(title: "Registration"),
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Enter your Name',
                        labelText: 'Name',
                      ),
                      validator:
                          RequiredValidator(errorText: "name is required"),
                      onChanged: (val) {
                        model.name = val;
                      },
                    )),
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
                Container(
                    padding: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      child: Text('Registration'),
                      onPressed: () => {
                        if (_formKey.currentState.validate())
                          {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(
                                          model: model,
                                        )),
                                (route) => false)
                          }
                      },
                    )),
                Container(
                    padding: EdgeInsets.only(top: 5),
                    child: FlatButton(
                      child: Text('Old User? Login'),
                      onPressed: () => {Navigator.pop(context)},
                    )),
              ],
            )));
  }
}
