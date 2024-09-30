import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xff40b65b);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: primaryGreen,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.light(
      primary: primaryGreen,
      secondary: primaryGreen,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryGreen,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(color: primaryGreen),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      color: primaryGreen,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryGreen,
      secondary: primaryGreen,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryGreen,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(color: primaryGreen),
    ),
  );
}