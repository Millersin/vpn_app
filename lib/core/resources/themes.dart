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

/// Градиент для светлой темы
final LinearGradient lightBackgroundGradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [const Color(0xFF7C619C), const Color(0xFFD5B4E5)],
);

/// Градиент для темной темы
final LinearGradient darkBackgroundGradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [const Color(0xFF140C24), const Color(0xFF63347B)],
);
