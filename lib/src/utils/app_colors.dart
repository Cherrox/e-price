import 'package:flutter/material.dart';

class AppColors {
  static const black = Color(0xFF000000);
  static const orange = Color(0xFFFF6A00);
  static const orangeAccent = Color(0xFFFFA800);
  static const pink = Color(0xFFEA138E);
  static const white = Color(0xFFFFFFFF);
    static const headerColor = Color(0xffE9ECF9);
  //darkColor
  static const darkColor = Color(0xFF1A1A1A);
  //lightColor
  static const lightColor = Color(0xFFE5E5E5);
  //blueColors
  static const blueColors = Color(0xFF00A0FF);
  //greyColors
  static const greyColors = Color(0xFFBDBDBD);
  //

  //degradados
  static const gradientOrange = LinearGradient(
    colors: [orange, Color(0xFFFFA800)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientPink = LinearGradient(
    colors: [pink, Color(0xFFD41A8C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientBlack = LinearGradient(
    colors: [black, Color(0xFF434343)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientPinkOrange = LinearGradient(
    colors: [pink, orange],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
