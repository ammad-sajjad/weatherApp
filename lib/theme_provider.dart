import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = ThemeData.dark(useMaterial3: true);

  ThemeData get themeData => _themeData;

  void ThemeState(){
    _themeData = (_themeData.brightness == Brightness.light)
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    notifyListeners();
  }
}