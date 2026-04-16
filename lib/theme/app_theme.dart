import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Sophisticated modern color palette
  static const Color backgroundBase = Color(0xFF0F172A); // Slate 900
  static const Color backgroundSurface = Color(0xFF1E293B); // Slate 800
  static const Color primaryAccent = Color(0xFF800000); // PUST Maroon
  static const Color secondaryAccent = Color(0xFF228B22); // PUST Green
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure White
  static const Color textSecondary = Color(0xFFFFFFFF); // Pure White

  // Modern Theme Definition
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryAccent,
    primaryColorDark: const Color(0xFF5C0000), // Darker Maroon
    scaffoldBackgroundColor: backgroundBase,
    cardColor: backgroundSurface,
    dialogBackgroundColor: backgroundSurface,
    
    // Applying Google Fonts across the entire TextTheme
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(color: textPrimary, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.outfit(color: textPrimary, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.outfit(color: textPrimary, fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.outfit(color: textPrimary, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.outfit(color: textPrimary, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.outfit(color: textPrimary),
      bodyMedium: GoogleFonts.outfit(color: textPrimary),
      bodySmall: GoogleFonts.outfit(color: textSecondary),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: backgroundBase,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20, 
        fontWeight: FontWeight.w600, 
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 8,
        shadowColor: primaryAccent.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: secondaryAccent,
        side: const BorderSide(color: secondaryAccent, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      prefixIconColor: textSecondary,
      labelStyle: GoogleFonts.outfit(color: textSecondary),
      hintStyle: GoogleFonts.outfit(color: textSecondary.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    ),

    cardTheme: CardThemeData(
      color: backgroundSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF334155), width: 1), // subtle border
      ),
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryAccent,
      foregroundColor: Colors.white,
      elevation: 8,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: backgroundSurface,
      selectedItemColor: primaryAccent,
      unselectedItemColor: textSecondary,
      elevation: 20,
      type: BottomNavigationBarType.fixed,
    ),
    
    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
      space: 1,
    ),
  );
}
