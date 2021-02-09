import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeMode extends ChangeNotifier {
  bool _isDark = false;
  AppThemeMode() {
    _getTheme();
  }
  _getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool("IsDark") ?? false;
  }

  Future<void> setTheme(bool isdark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IsDark", isdark);
    _isDark = isdark;
    notifyListeners();
  }

  bool getTheme() {
    return _isDark;
  }
}
