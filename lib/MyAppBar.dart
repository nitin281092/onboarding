import 'package:flutter/material.dart';
import 'package:onboarding/AppThemeMode.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  MyAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<AppThemeMode>(context);
    return AppBar(title: Text(title), actions: <Widget>[
      Padding(padding: EdgeInsets.only(top: 20.0), child: Text("Dark Mode")),
      Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Checkbox(
          value: darkTheme.getTheme(),
          onChanged: (bool value) {
            darkTheme.setTheme(value);
          },
        ),
      ),
    ]);
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
