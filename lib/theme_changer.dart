import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  ThemeChanger() {
    _baseColor = Colors.blue;
    isDarkTheme = false;
    updateThemeData();
  }
  ThemeData themeData;
  bool isDarkTheme;

  MaterialColor _baseColor;
  MaterialColor get baseColor => _baseColor;

  set baseColorbyColor(MaterialColor color) {
    _baseColor = color;
    updateThemeData();
  }

  setDarkTheme(bool isDark) async {
    isDarkTheme = isDark ?? false;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isDark', isDarkTheme);
    notifyListeners();
  }

  toggleDarkTheme() async {
    isDarkTheme = !isDarkTheme;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isDark', isDarkTheme);
    notifyListeners();
  }

  set baseColorByString(String value) {
    if (value != null && value.isNotEmpty) {
      List<MaterialColor> colorsList = <MaterialColor>[
        Colors.red,
        Colors.deepOrange,
        Colors.orange,
        Colors.amber,
        Colors.green,
        Colors.lightGreen,
        Colors.lime,
        Colors.yellow,
        Colors.indigo,
        Colors.blue,
        Colors.lightBlue,
        Colors.cyan,
        Colors.teal,
        Colors.deepPurple,
        Colors.purple,
        Colors.pink,
        Colors.brown,
        Colors.grey,
      ];

      _baseColor = colorsList.firstWhere(
        (element) => value == element.toString(),
        orElse: () => Colors.blue,
      );
      updateThemeData();
      notifyListeners();
    }
  }

  updateThemeData() {
    themeData = ThemeData.light().copyWith(
      primaryColor: baseColor[800],
      accentColor: baseColor[400],
      backgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
    notifyListeners();
  }
}
