import 'package:flutter/material.dart';
import 'package:nerdvpn/core/resources/colors.dart';

ThemeData get lightTheme => ThemeData.light().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      dividerTheme: DividerThemeData(color: Colors.grey.shade300),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      radioTheme: const RadioThemeData(fillColor: WidgetStatePropertyAll(primaryColor)),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        brightness: Brightness.light,
        shadow: shadowColor,
        surface: surfaceLight,
      ),
    );

ThemeData get darkTheme => ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDark,
      dividerTheme: DividerThemeData(color: Colors.grey.shade900),
      radioTheme: const RadioThemeData(fillColor: WidgetStatePropertyAll(primaryColor)),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        brightness: Brightness.dark,
        shadow: shadowColor,
        surface: surfaceDark,
      ),
    );

TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
