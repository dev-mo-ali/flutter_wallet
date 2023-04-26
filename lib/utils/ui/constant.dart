import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Colors.deepOrangeAccent;
  static const accent = Color(0xffFFC100);
  static const backgroundDark = Color(0xFF171822);
  static const background = Colors.white;
  static const backgroundLight = Color(0xFFF1F3F6);
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      backgroundColor: const MaterialStatePropertyAll(AppColors.accent),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      foregroundColor: const MaterialStatePropertyAll(Color(0xff212330)),
      textStyle: MaterialStatePropertyAll(
        GoogleFonts.poppins(
          fontSize: 15,
          height: 1.6,
          color: const Color(0xff212330),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const MaterialStatePropertyAll(Color(0xff1B1D28)),
      textStyle: MaterialStatePropertyAll(
        GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xff1B1D28),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),
  backgroundColor: AppColors.background,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  cardColor: const Color(0xffF1F3F6),
  iconTheme: const IconThemeData(
    color: Color(0xFF3A4276),
  ),
  textTheme: TextTheme(
    labelLarge: GoogleFonts.poppins(
      fontSize: 15,
      height: 1.6,
      color: const Color(0xff212330),
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 12,
      color: const Color(0xff1B1D28),
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.poppins(
      height: 1.6,
      fontSize: 12,
      color: const Color(0xff7b7f9e),
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 24,
      color: const Color(0xff171822),
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 22,
      color: const Color(0xff3A4276),
      fontWeight: FontWeight.w800,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 15,
      color: const Color(0xff3A4276),
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 22,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    ),
  ),
  colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: AppColors.backgroundLight),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          elevation: MaterialStatePropertyAll(0),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12))))),
  backgroundColor: AppColors.backgroundDark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  iconTheme: const IconThemeData(
    color: Color(0xff7b7f9e),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const MaterialStatePropertyAll(Color(0xffffffff)),
      textStyle: MaterialStatePropertyAll(
        GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),
  cardColor: const Color(0xFF212330),
  textTheme: TextTheme(
    bodyMedium: GoogleFonts.poppins(
      fontSize: 12,
      color: const Color(0xffffffff),
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.poppins(
      height: 1.6,
      fontSize: 12,
      color: const Color(0xff7b7f9e),
      fontWeight: FontWeight.w400,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 15,
      height: 1.6,
      color: const Color(0xff212330),
      fontWeight: FontWeight.w600,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 24,
      color: const Color(0xFFFFFFFF),
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 22,
      color: const Color(0xFFFFFFFF),
      fontWeight: FontWeight.w800,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 15,
      color: const Color(0xff7b7f9e),
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
  ),
);
