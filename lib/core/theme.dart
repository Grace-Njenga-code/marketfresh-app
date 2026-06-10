import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primarySurface = Color(0xFFE8F5E9);

  static const Color accent = Color(0xFFFF6F00);
  static const Color accentLight = Color(0xFFFFB300);
  static const Color accentSurface = Color(0xFFFFF8E1);

  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  static const Color shadow = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primarySurface,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.accent,
        onSecondary: AppColors.textOnPrimary,
        secondaryContainer: AppColors.accentSurface,
        onSecondaryContainer: AppColors.accent,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        outline: AppColors.divider,
        shadow: AppColors.shadow,
        scrim: AppColors.shadowMedium,
        inverseSurface: AppColors.textPrimary,
        onInverseSurface: AppColors.surface,
        inversePrimary: AppColors.primaryLight,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: _buildAppBarTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      cardTheme: _buildCardTheme(),
      chipTheme: _buildChipTheme(),
      bottomNavigationBarTheme: _buildBottomNavTheme(),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: _buildSnackBarTheme(),
      dialogTheme: _buildDialogTheme(),
    );
  }

  static TextTheme _buildTextTheme() {
    return GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5),
      displayMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5),
      displaySmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      headlineLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      headlineMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      headlineSmall: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleMedium: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
      titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.4),
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.1),
      labelMedium: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 0.5),
      labelSmall: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textHint, letterSpacing: 0.5),
    );
  }

  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.shadow,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.divider,
        disabledForegroundColor: AppColors.textHint,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        minimumSize: const Size(double.infinity, 52),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        minimumSize: const Size(double.infinity, 52),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
      hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textHint),
      labelStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
      prefixIconColor: AppColors.textSecondary,
      suffixIconColor: AppColors.textSecondary,
    );
  }

  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.divider, width: 1),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    );
  }

  static ChipThemeData _buildChipTheme() {
    return ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primarySurface,
      labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
      secondaryLabelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide.none),
      elevation: 0,
      pressElevation: 0,
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavTheme() {
    return BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w400),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    );
  }

  static SnackBarThemeData _buildSnackBarTheme() {
    return SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.surface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    );
  }

  static DialogThemeData _buildDialogTheme() {
    return DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: 8,
      shadowColor: AppColors.shadowMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      contentTextStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
    );
  }
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double full = 100;
}

class AppShadows {
  static List<BoxShadow> get small => [
        const BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
      ];

  static List<BoxShadow> get medium => [
        const BoxShadow(color: AppColors.shadowMedium, blurRadius: 16, offset: Offset(0, 4)),
      ];

  static List<BoxShadow> get card => [
        const BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 2)),
        const BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 1)),
      ];
}