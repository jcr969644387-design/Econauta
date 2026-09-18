import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Colores de Econauta que se adaptan al tema claro u oscuro.
///
/// Las pantallas piden sus colores con [AppColors.of] en lugar de usar
/// constantes fijas, para que el modo oscuro se vea correcto en todas ellas.
@immutable
class AppColors {
  const AppColors._({
    required this.accent,
    required this.heading,
    required this.muted,
    required this.border,
    required this.softSurface,
    required this.cardSurface,
    required this.positive,
    required this.negative,
    required this.warning,
    required this.noticeSurface,
    required this.noticeBorder,
    required this.headerSurface,
    required this.headerText,
  });

  /// Devuelve la paleta correspondiente al tema activo.
  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  /// Paleta del tema claro.
  static const AppColors light = AppColors._(
    accent: AppPalette.primary,
    heading: AppPalette.primaryDark,
    muted: AppPalette.neutral,
    border: AppPalette.border,
    softSurface: AppPalette.surfaceSoft,
    cardSurface: Colors.white,
    positive: AppPalette.positive,
    negative: AppPalette.negative,
    warning: AppPalette.warning,
    noticeSurface: Color(0xFFFFF6E5),
    noticeBorder: Color(0xFFE8D3A9),
    headerSurface: AppPalette.primary,
    headerText: Color(0xFFFFFFFF),
  );

  /// Paleta del tema oscuro.
  static const AppColors dark = AppColors._(
    accent: Color(0xFF6FD2AC),
    heading: Color(0xFFE2F1EB),
    muted: Color(0xFFA3B4AE),
    border: Color(0xFF2C3A35),
    softSurface: Color(0xFF17211E),
    cardSurface: Color(0xFF131C19),
    positive: Color(0xFF5CD08C),
    negative: Color(0xFFFF8F80),
    warning: Color(0xFFE8BA6A),
    noticeSurface: Color(0xFF241F14),
    noticeBorder: Color(0xFF4A3D24),
    headerSurface: Color(0xFF16302A),
    headerText: Color(0xFFDCEDE6),
  );

  /// Color de acento para botones y valores destacados.
  final Color accent;

  /// Color de titulos y cifras principales.
  final Color heading;

  /// Color de textos secundarios.
  final Color muted;

  /// Color de bordes de tarjetas y controles.
  final Color border;

  /// Fondo de las tarjetas de indicadores.
  final Color softSurface;

  /// Fondo de las tarjetas de seccion.
  final Color cardSurface;

  /// Color para variaciones favorables.
  final Color positive;

  /// Color para variaciones desfavorables.
  final Color negative;

  /// Color de avisos.
  final Color warning;

  /// Fondo del aviso educativo.
  final Color noticeSurface;

  /// Borde del aviso educativo.
  final Color noticeBorder;

  /// Fondo del encabezado de la pantalla principal.
  final Color headerSurface;

  /// Color del texto del encabezado de la pantalla principal.
  final Color headerText;
}

/// Construye los temas claro y oscuro de la aplicacion.
class AppTheme {
  const AppTheme._();

  /// Tema claro.
  static ThemeData get light => _build(Brightness.light, AppColors.light);

  /// Tema oscuro.
  static ThemeData get dark => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors colors) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: brightness,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? const Color(0xFF0E1614) : Colors.white,
      dividerColor: colors.border,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF13211D) : AppPalette.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 3,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: isDark ? const Color(0xFF07251C) : Colors.white,
          minimumSize: const Size.fromHeight(48),
          animationDuration: const Duration(milliseconds: 180),
          shape: shape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.heading,
          side: BorderSide(color: colors.border),
          animationDuration: const Duration(milliseconds: 180),
          shape: shape,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.accent,
        thumbColor: colors.accent,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.accent,
        textColor: colors.heading,
      ),
    );
  }
}
