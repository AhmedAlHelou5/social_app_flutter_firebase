import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../res/i_font_res.dart';
import '../colors/colors.dart';

ThemeData darkTheme =  ThemeData(
    // useMaterial3: true,
    primarySwatch: defaultColor,
    scaffoldBackgroundColor: HexColor('333739'),
    appBarTheme: AppBarTheme(
      titleSpacing: 20,

      titleTextStyle: TextStyle(
        fontSize: 20,
        fontFamily: 'Jannabold',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      elevation: 0,
      backgroundColor: HexColor('333739'),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('333739'),
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: Colors.white),

    ),
    floatingActionButtonTheme:const FloatingActionButtonThemeData(
        backgroundColor: defaultColor
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepOrange,
      elevation: 20,
      unselectedItemColor: Colors.grey,
      backgroundColor: HexColor('333739'),
    ),
    textTheme:const TextTheme(
        bodyText1: TextStyle(
          fontSize: 18,
          fontFamily: 'Jannabold',
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        subtitle1: TextStyle(
          fontSize: 14,
          fontFamily: 'Jannabold',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.3
        )
    ),
    fontFamily: FontRes.JANNABOLD


);


ThemeData lightTheme = ThemeData(
    primarySwatch: defaultColor,
    primaryColor: defaultColor,
    iconTheme: const IconThemeData(color: Colors.black),
    // useMaterial3: true,
    appBarTheme: const AppBarTheme(
      titleSpacing: 20,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontFamily: 'Jannabold',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),

    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: defaultColor
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepOrange,
      elevation: 20,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    ),

    textTheme:const TextTheme(
        bodyText1: TextStyle(
          fontSize: 18,
          fontFamily: 'Jannabold',
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      subtitle1: TextStyle(
        fontSize: 14,
        fontFamily: 'Jannabold',
        fontWeight: FontWeight.w600,
        color: Colors.black,
          height: 1.3

      )
    ),
  fontFamily: FontRes.JANNABOLD


);