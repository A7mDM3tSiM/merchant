import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blueAccent,
    titleTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
  colorScheme: const ColorScheme(
    background: Colors.white,
    brightness: Brightness.light,
    error: Colors.redAccent,
    onBackground: Colors.white,
    onError: Colors.redAccent,
    onPrimary: Colors.blueAccent,
    onSecondary: Colors.grey,
    onSurface: Colors.white,
    primary: Colors.blueAccent,
    secondary: Colors.grey,
    surface: Colors.white,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: Colors.black,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[300],
    border: InputBorder.none,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.grey,
    titleTextStyle: TextStyle(
      color: Colors.black,
    ),
  ),
  colorScheme: const ColorScheme(
    background: Colors.black,
    brightness: Brightness.dark,
    error: Colors.redAccent,
    onBackground: Colors.grey,
    onError: Colors.redAccent,
    onPrimary: Colors.grey,
    onSecondary: Colors.grey,
    onSurface: Colors.grey,
    primary: Colors.grey,
    secondary: Colors.grey,
    surface: Colors.grey,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey,
    border: InputBorder.none,
  ),
);
