import 'package:flutter/material.dart';

class ThemeManegerProvider with ChangeNotifier {
  var _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  set themeMode(var value) {
    if (value is ThemeMode) {
      _themeMode = value;
      notifyListeners();
    }
  }

  void switchMode(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
