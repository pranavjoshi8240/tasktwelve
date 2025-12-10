import 'dart:math' as math;

import 'package:flutter/material.dart';

const Color colorPrimary = Color(0xFFC5E8FE);
const Color colorPrimary2 = Color(0xFF090A2D);

const Color color090A2D = Color(0xFF090A2D);
const Color colorAppBg = Color(0xFFFFFFFF);
const Color colorCCCCCC = Color(0xFFCCCCCC);
const Color colorTransparent = Colors.transparent;
const Color colorBlack = Color(0xFF000000);
const Color colorWhite = Color(0xFFFFFFFF);
const Color colorD9D3DD = Color(0xFFD9D3DD);
const Color colorDA2D2D = Color(0xFFDA2D2D);
const Color color738899 = Color(0xFF738899);
const Color colorF3EDF7 = Color(0xFFF3EDF7);
const Color color108600 = Color(0xFF108600);
const Color colorC5E8FE = Color(0xFFC5E8FE);
const Color colorFF6264 = Color(0xFFFF6264);
const Color colorFFCECE = Color(0xFFFFCECE);
const Color color19204C = Color(0xFF19204C);
const Color colorA87A00 = Color(0xFFA87A00);
const Color colorFF4848 = Color(0xFFFF4848);
const Color color267904 = Color(0xFF267904);
const Color color0FAF00 = Color(0xFF0FAF00);
const Color colorAD0000 = Color(0xFFAD0000);
const Color colorBlueText = Color(0xFF4F8EE1);
const Color color0F77F0 = Color(0xFF0F77F0);
const Color colorA475DD = Color(0xFFA475DD);
const Color color68BDEB = Color(0xFF68BDEB);
const Color colorD50000 = Color(0xFFD50000);

const MaterialColor customSwatch = MaterialColor(
  0xFFC5E8FE,
  <int, Color>{
    50: Color(0xFFE6F5FF),
    100: Color(0xFFD9F0FF),
    200: Color(0xFFBFE2FE),
    300: Color(0xFFA5D3FE),
    400: Color(0xFF8AC4FE),
    500: Color(0xFFC5E8FE), // Primary color
    600: Color(0xFF61A5FE),
    700: Color(0xFF4783FD),
    800: Color(0xFF2D60FD),
    900: Color(0xFF133DFD),
  },
);

Gradient gradientPrimary = const LinearGradient(
  begin: Alignment(0, -0.6),
  end: Alignment(0.1, 4),
  colors: [
    Color.fromRGBO(237, 39, 48, 1),
    Color.fromRGBO(251, 188, 5, 1),
  ],
  transform: GradientRotation(math.pi - 550),
);
