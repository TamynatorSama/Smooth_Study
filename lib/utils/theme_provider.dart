import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_study/utils/storage_manager.dart';

class ThemeProvider with ChangeNotifier {
  final darkTheme = ThemeData(
    canvasColor: const Color(0xFF6259FF),
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
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.dark,
    dividerColor: Colors.black12,
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF383838),
    ),
    cardColor: const Color(0xFF6259FF),
  );

  final lightTheme = ThemeData(
    canvasColor: const Color(0xFF6259FF),
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
    primaryColor: Colors.black,
    brightness: Brightness.light,
    dividerColor: Colors.white54,
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF1D1D1D),
    ),
    cardColor: const Color(0xFF6259FF),
  );

  late bool isDarkMode = false;

  late ThemeData _themeData = lightTheme;
  ThemeData getTheme() => _themeData;

  ThemeProvider() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: Colors.black,
            statusBarColor: Colors.transparent,
          ),
        );
        isDarkMode = false;
        _themeData = lightTheme;
      } else {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.transparent,
          ),
        );
        isDarkMode = true;
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    isDarkMode = true;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
      ),
    );
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    isDarkMode = false;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.transparent,
      ),
    );
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
