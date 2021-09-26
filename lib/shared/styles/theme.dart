import 'package:chat_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: defaultColor,
  fontFamily: 'Jannah',
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    actionsIconTheme: IconThemeData(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontFamily: 'Jannah',
      fontWeight: FontWeight.bold,
      fontSize: 25.0,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleSpacing: 10.0,
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18.0,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    subtitle1: TextStyle(
      fontSize: 14.0,
      color: Colors.black,
      height: 1.3,
      fontWeight: FontWeight.w600,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Jannah',
  appBarTheme: const AppBarTheme(
    actionsIconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontFamily: 'Jannah',
      fontWeight: FontWeight.bold,
      fontSize: 25.0,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleSpacing: 10.0,
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: HexColor(
      '333739',
    ),
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18.0,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    subtitle1: TextStyle(
      fontSize: 14.0,
      color: Colors.white,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
  ),
);
