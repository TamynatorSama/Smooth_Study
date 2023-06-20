import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_study/utils/storage_manager.dart';

class ThemeProvider with ChangeNotifier {
  final darkTheme = ThemeData(
  
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.josefinSans(
        fontSize: 22,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.josefinSans(
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.josefinSans(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    dividerColor: Colors.black12,
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF383838),
    ),
    cardColor: const Color(0xFF585858),
  );

  final lightTheme = ThemeData(
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.josefinSans(
        fontSize: 22,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.josefinSans(
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: Colors.black,
      ),
      bodySmall: GoogleFonts.josefinSans(
        fontSize: 18,
        color: Colors.black,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    dividerColor: Colors.white54,
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF1D1D1D),
    ),
    cardColor: const Color(0xFFD9D9D9),
  );

  late bool isDarkMode;

  late ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeProvider() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ${value.toString()}');
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        isDarkMode = false;
        _themeData = lightTheme;
      } else {
        isDarkMode = true;
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    isDarkMode = true;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    isDarkMode = false;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
