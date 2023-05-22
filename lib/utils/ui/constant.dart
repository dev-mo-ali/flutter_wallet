import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Colors.deepOrangeAccent;
  static const accent = Color(0xffFFC100);
  static const accentDark = Color(0xff3A4276);
  static const backgroundDark = Color(0xFF171822);
  static const background = Colors.white;
  static const backgroundLight = Color(0xFFF1F3F6);
}

ThemeData lightTheme() => ThemeData(
      brightness: Brightness.light,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
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
          foregroundColor: const MaterialStatePropertyAll(AppColors.accent),
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(color: Colors.red),
        prefixIconColor: const Color(0xFF3A4276),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          height: 1.4,
          color: const Color(0xff212330),
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          height: 1.4,
          color: const Color(0xff212330),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blueGrey.shade800),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xffF1F3F6),
        foregroundColor: Color(0xFF3A4276),
      ),
      scaffoldBackgroundColor: AppColors.background,
      radioTheme: const RadioThemeData(
        overlayColor: MaterialStatePropertyAll(Color(0xFF3A4276)),
        fillColor: MaterialStatePropertyAll(Color(0xFF3A4276)),
      ),
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
          fontWeight: FontWeight.w500,
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
          fontSize: 20,
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
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        selectedIconTheme: IconThemeData(
          color: Color(0xff3A4276),
        ),
        selectedItemColor: Color.fromARGB(255, 186, 148, 33),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(
              primary: const Color(0xFF3A4276),
              brightness: Brightness.light,
              secondary: AppColors.backgroundLight,
              outline: Colors.grey.shade600)
          .copyWith(background: AppColors.background),
    );

ThemeData darkTheme() => ThemeData(
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
          backgroundColor: const MaterialStatePropertyAll(AppColors.accent),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          foregroundColor: const MaterialStatePropertyAll(Colors.white70),
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.poppins(
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const MaterialStatePropertyAll(Colors.white70),
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(color: Colors.red),
        prefixIconColor: const Color(0xff7b7f9e),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          height: 1.4,
          color: const Color(0xFF848AB0),
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          height: 1.6,
          color: const Color(0xFF848AB0),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blueGrey.shade800),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF212330),
        foregroundColor: Color(0xff7b7f9e),
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      radioTheme: const RadioThemeData(
        overlayColor: MaterialStatePropertyAll(Color(0xff7b7f9e)),
        fillColor: MaterialStatePropertyAll(Color(0xff7b7f9e)),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xff7b7f9e),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 35, 36, 43),
        selectedIconTheme: IconThemeData(
          color: Color.fromARGB(255, 186, 148, 33),
        ),
        selectedItemColor: Color.fromARGB(255, 186, 148, 33),
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
          color: const Color(0xFF848AB0),
          fontWeight: FontWeight.w500,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 20,
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
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(
          brightness: Brightness.dark,
          primary: const Color(0xff7b7f9e),
          secondary: AppColors.backgroundDark,
          outline: Colors.grey.shade300).copyWith(background: AppColors.backgroundDark),
    );
