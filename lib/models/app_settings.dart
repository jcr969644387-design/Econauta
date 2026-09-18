import 'package:flutter/material.dart';

/// Preferencias de experiencia que el estudiante puede cambiar.
@immutable
class AppSettings {
  /// Crea una configuracion con los valores indicados.
  const AppSettings({
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.themeMode = ThemeMode.system,
  });

  /// Configuracion usada la primera vez que se abre la aplicacion.
  static const AppSettings initial = AppSettings();

  /// Indica si los efectos de sonido estan activos.
  final bool soundEnabled;

  /// Indica si la vibracion esta activa.
  final bool hapticsEnabled;

  /// Tema seleccionado: claro, oscuro o el del sistema.
  final ThemeMode themeMode;

  /// Devuelve una copia con los valores indicados.
  AppSettings copyWith({
    bool? soundEnabled,
    bool? hapticsEnabled,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AppSettings &&
        other.soundEnabled == soundEnabled &&
        other.hapticsEnabled == hapticsEnabled &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => Object.hash(soundEnabled, hapticsEnabled, themeMode);
}
