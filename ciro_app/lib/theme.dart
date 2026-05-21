import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CiroColors {
  // Base
  static const Color creamBg = Color(0xFFF5F1EA);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Navy (Brand/Text)
  static const Color navyDark = Color(0xFF1E3A4A);
  static const Color navyText = Color(0xFF2B3A48);
  static const Color navyLight = Color(0xFF324A5E);

  // Teal
  static const Color tealPrimary = Color(0xFF5FA3B8);
  static const Color tealLight = Color(0xFF7EB5C8);
  static const Color tealDark = Color(0xFF2B6478);
  static const Color tealBg = Color(0xFFDCEEF3);
  static const Color tealBorder = Color(0xFFBCDDE5);

  // Tan/Gold
  static const Color tanText = Color(0xFFA8854F);
  static const Color tanGradientStart = Color(0xFFC9A876);
  static const Color tanGradientEnd = Color(0xFFA8854F);

  // Greys
  static const Color greyText = Color(0xFF8898A4);
  static const Color greyDark = Color(0xFF5A6B78);
  static const Color greyBorder = Color(0xFFE3E8EC);
  static const Color greyLightBorder = Color(0xFFEEF2F5);
  static const Color greyIcon = Color(0xFFCDD5DC);

  // Semantic
  static const Color danger = Color(0xFFD04545);
  static const Color warning = Color(0xFFD07E45); // Extrapolated for MEDIUM
  static const Color success = Color(0xFF5FA890);
}

class CiroTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: CiroColors.creamBg,
      primaryColor: CiroColors.tealPrimary,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: CiroColors.navyText,
        displayColor: CiroColors.navyDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: CiroColors.navyDark),
        titleTextStyle: TextStyle(
          color: CiroColors.navyDark,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: CiroColors.tealPrimary,
        primary: CiroColors.tealPrimary,
        secondary: CiroColors.tanText,
        error: CiroColors.danger,
        surface: CiroColors.white,
      ),
    );
  }

  // Common UI Styles
  static BoxDecoration cardDecoration = BoxDecoration(
    color: CiroColors.white,
    borderRadius: BorderRadius.circular(24), // 3xl
    border: Border.all(color: CiroColors.greyLightBorder),
    boxShadow: [
      BoxShadow(
        color: CiroColors.navyDark.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
        spreadRadius: -4,
      ),
    ],
  );
}
