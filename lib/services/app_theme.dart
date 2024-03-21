import 'package:flutter/material.dart';

// Define your app theme
final ThemeData appTheme = ThemeData(
  // Define your app colors
  primaryColor: Colors.deepPurple,
  // accentColor: Colors.orange,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.deepPurple,
    // accentColor: Colors.orange,
  ),
  // Define your text theme
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.black),
    bodyText2: TextStyle(color: Colors.black),
  ),
  // Define your app bar theme
  appBarTheme: AppBarTheme(
    color: Colors.deepPurple,
  ),
  // Define your button theme
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.deepPurple,
  ),
  // Define your icon theme
  iconTheme: IconThemeData(
    color: Colors.deepPurple,
  ),
);
