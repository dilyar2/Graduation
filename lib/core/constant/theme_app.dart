import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation2/core/constant/color_app.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({required this.special});

  final TextStyle special;

  @override
  AppTypography copyWith({TextStyle? special}) =>
      AppTypography(special: special ?? this.special);

  @override
  AppTypography lerp(covariant AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      special: TextStyle.lerp(special, other.special, t) ?? special,
    );
  }
}

class ThemeApp {
  ThemeApp._();

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: ColorApp.lightBlue,
      onPrimary: ColorApp.lightCard,
      secondary: ColorApp.lightOrange,
      onSecondary: ColorApp.lightPrimaryText,
      surface: ColorApp.lightCard,
      onSurface: ColorApp.lightPrimaryText,
      onSurfaceVariant: ColorApp.lightSecondaryText,
      surfaceContainerHighest: ColorApp.lightSurface,
      error: Color(0xFFDC2626),
      onError: ColorApp.lightCard,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ColorApp.lightBackground,
      cardColor: ColorApp.lightCard,
      splashFactory: InkSparkle.splashFactory,
      fontFamily: GoogleFonts.karla().fontFamily,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: ColorApp.lightBackground,
        foregroundColor: ColorApp.lightPrimaryText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: ColorApp.lightPrimaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: _textTheme(
        ColorApp.lightPrimaryText,
        ColorApp.lightSecondaryText,
        ColorApp.lightTertiaryText,
      ),
      cardTheme: CardThemeData(
        color: ColorApp.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: ColorApp.lightSurface),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorApp.lightCard,
        labelStyle: GoogleFonts.karla(color: ColorApp.lightSecondaryText),
        hintStyle: GoogleFonts.karla(color: ColorApp.lightTertiaryText),
        prefixIconColor: ColorApp.lightBlue,
        suffixIconColor: ColorApp.lightSecondaryText,
        border: _inputBorder(ColorApp.lightSurface),
        enabledBorder: _inputBorder(ColorApp.lightSurface),
        focusedBorder: _inputBorder(ColorApp.lightBlue, width: 2),
        errorBorder: _inputBorder(scheme.error),
        focusedErrorBorder: _inputBorder(scheme.error, width: 2),
      ),
      elevatedButtonTheme: _buttonTheme(
        background: ColorApp.lightBlue,
        foreground: ColorApp.lightCard,
      ),
      outlinedButtonTheme: _outlinedButtonTheme(ColorApp.lightBlue),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorApp.lightBlue,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ColorApp.lightCard,
        indicatorColor: ColorApp.lightBlue.withValues(alpha: .12),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.karla(fontWeight: FontWeight.w600),
        ),
      ),
      iconTheme: const IconThemeData(color: ColorApp.lightSecondaryText),
      dividerTheme: const DividerThemeData(
        color: ColorApp.lightSurface,
        thickness: 1,
      ),
      extensions: [
        AppTypography(
          special: GoogleFonts.offside(
            color: ColorApp.lightOrange,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: ColorApp.darkBlue,
      onPrimary: ColorApp.darkBackground,
      secondary: ColorApp.darkOrange,
      onSecondary: ColorApp.darkBackground,
      surface: ColorApp.darkCard,
      onSurface: ColorApp.darkTertiaryText,
      onSurfaceVariant: ColorApp.darkSecondaryText,
      surfaceContainerHighest: ColorApp.darkSurface,
      error: Color(0xFFF87171),
      onError: ColorApp.darkBackground,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ColorApp.darkBackground,
      cardColor: ColorApp.darkCard,
      splashFactory: InkSparkle.splashFactory,
      fontFamily: GoogleFonts.karla().fontFamily,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: ColorApp.darkBackground,
        foregroundColor: ColorApp.darkTertiaryText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: ColorApp.darkTertiaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: _textTheme(
        ColorApp.darkTertiaryText,
        ColorApp.darkSecondaryText,
        ColorApp.darkSecondaryText,
      ),
      cardTheme: CardThemeData(
        color: ColorApp.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: ColorApp.darkSurface),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorApp.darkSurface,
        labelStyle: GoogleFonts.karla(color: ColorApp.darkTertiaryText),
        hintStyle: GoogleFonts.karla(color: ColorApp.darkSecondaryText),
        prefixIconColor: ColorApp.darkBlueSecondary,
        suffixIconColor: ColorApp.darkSecondaryText,
        border: _inputBorder(ColorApp.darkSurface),
        enabledBorder: _inputBorder(ColorApp.darkSurface),
        focusedBorder: _inputBorder(ColorApp.darkBlue, width: 2),
        errorBorder: _inputBorder(scheme.error),
        focusedErrorBorder: _inputBorder(scheme.error, width: 2),
      ),
      elevatedButtonTheme: _buttonTheme(
        background: ColorApp.darkBlue,
        foreground: ColorApp.darkBackground,
      ),
      outlinedButtonTheme: _outlinedButtonTheme(ColorApp.darkBlueSecondary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorApp.darkBlue,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ColorApp.darkCard,
        indicatorColor: ColorApp.darkBlue.withValues(alpha: .16),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.karla(fontWeight: FontWeight.w600),
        ),
      ),
      iconTheme: const IconThemeData(color: ColorApp.darkTertiaryText),
      dividerTheme: const DividerThemeData(
        color: ColorApp.darkSurface,
        thickness: 1,
      ),
      extensions: [
        AppTypography(
          special: GoogleFonts.offside(
            color: ColorApp.darkOrange,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  static TextTheme _textTheme(
    Color primary,
    Color secondary,
    Color tertiary,
  ) {
    final karla = GoogleFonts.karlaTextTheme().apply(
      bodyColor: primary,
      displayColor: primary,
    );

    final space = GoogleFonts.spaceGroteskTextTheme();

    return karla.copyWith(
      displayLarge: space.displayLarge?.copyWith(color: primary),
      displayMedium: space.displayMedium?.copyWith(color: primary),
      displaySmall: space.displaySmall?.copyWith(color: primary),
      headlineLarge: space.headlineLarge?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: space.headlineMedium?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: space.headlineSmall?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: space.titleLarge?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: space.titleMedium?.copyWith(color: secondary),
      titleSmall: space.titleSmall?.copyWith(color: tertiary),
      bodyLarge: karla.bodyLarge?.copyWith(color: primary),
      bodyMedium: karla.bodyMedium?.copyWith(color: secondary),
      bodySmall: karla.bodySmall?.copyWith(color: tertiary),
      labelLarge: karla.labelLarge?.copyWith(color: primary),
      labelMedium: karla.labelMedium?.copyWith(color: secondary),
      labelSmall: karla.labelSmall?.copyWith(color: tertiary),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );

  static ElevatedButtonThemeData _buttonTheme({
    required Color background,
    required Color foreground,
  }) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(background),
          foregroundColor: WidgetStatePropertyAll(foreground),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
          ),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(Color color) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(color),
          side: WidgetStatePropertyAll(BorderSide(color: color, width: 1.5)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
          ),
        ),
      );
}

extension AppThemeContext on BuildContext {
  AppTypography get appTypography =>
      Theme.of(this).extension<AppTypography>()!;
}
