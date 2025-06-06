import 'package:flutter/material.dart';

///General Colors
const Color primaryColor = Color(0xFF63347B);
const Color secondaryColor = Color(0xFF63347B);

const Color primaryShade = Color(0xFFD9A8F2);
const Color secondaryShade = Color(0xFFD9A8F2);

LinearGradient primaryGradient = const LinearGradient(
  colors: [primaryColor, primaryShade],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

LinearGradient greyGradient = LinearGradient(
  colors: [Colors.grey.withOpacity(.8), Colors.grey.withOpacity(.5)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

LinearGradient secondaryGradient = const LinearGradient(
  colors: [secondaryColor, secondaryShade],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

LinearGradient primarySecondaryGradient = const LinearGradient(
  colors: [primaryColor, primaryShade, secondaryShade, secondaryColor],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

///Light Theme
const Color backgroundLight = Color(0xFFF1DBFC);
const Color surfaceLight = Color(0xFFD5B4E5);

///Dark theme
const Color backgroundDark = Color(0xff180E28);
const Color surfaceDark = Color(0xff63347B);

Color get shadowColor => Colors.black.withOpacity(.05);
