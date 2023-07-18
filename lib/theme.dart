import 'package:collevo_teacher/colors.dart';
import 'package:collevo_teacher/text_theme.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: CustomColors.manga,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 28,
          color: CustomColors.manga,
        ),
      ),
      textTheme: const CustomTextTheme(),
      scaffoldBackgroundColor: CustomColors.voidColor,
      cardTheme: const CardTheme(
        color: CustomColors.blueGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.buttonBlue,
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 36.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.2),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          foregroundColor: CustomColors.surf,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // foregroundColor: CustomColors.buttonBlue,
          // backgroundColor: CustomColors.voidColor,
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 36.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        backgroundColor: CustomColors.voidColor,
      ).copyWith(surface: CustomColors.blueGray),
      dialogTheme: const DialogTheme(
        backgroundColor: CustomColors.blueGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
