import 'package:flutter/material.dart';
import 'package:onboarding/AppThemeMode.dart';
import 'package:provider/provider.dart';

import 'Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeMode appThemeMode = new AppThemeMode();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (a) {
        return appThemeMode;
      },
      child: Consumer<AppThemeMode>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme:
                appThemeMode.getTheme() ? ThemeData.dark() : ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: Login(),
          );
        },
      ),
    );
  }
}
