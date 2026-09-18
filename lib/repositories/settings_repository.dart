import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

/// Contrato de persistencia de las preferencias del estudiante.
///
/// Las pantallas nunca hablan con el almacenamiento directamente: usan este
/// repositorio a traves del controlador de configuracion.
abstract class SettingsRepository {
  /// Lee las preferencias guardadas.
  Future<AppSettings> load();

  /// Guarda las preferencias indicadas.
  Future<void> save(AppSettings settings);
}

/// Implementacion real sobre `shared_preferences`.
class PreferencesSettingsRepository implements SettingsRepository {
  static const String _soundKey = 'econauta.sound_enabled';
  static const String _hapticsKey = 'econauta.haptics_enabled';
  static const String _themeKey = 'econauta.theme_mode';

  @override
  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      soundEnabled: prefs.getBool(_soundKey) ?? true,
      hapticsEnabled: prefs.getBool(_hapticsKey) ?? true,
      themeMode: decodeThemeMode(prefs.getString(_themeKey)),
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, settings.soundEnabled);
    await prefs.setBool(_hapticsKey, settings.hapticsEnabled);
    await prefs.setString(_themeKey, settings.themeMode.name);
  }

  /// Convierte el valor guardado en un [ThemeMode] valido.
  static ThemeMode decodeThemeMode(String? value) {
    for (final mode in ThemeMode.values) {
      if (mode.name == value) {
        return mode;
      }
    }
    return ThemeMode.system;
  }
}

/// Implementacion en memoria usada por las pruebas.
class InMemorySettingsRepository implements SettingsRepository {
  /// Crea el repositorio con una configuracion inicial opcional.
  InMemorySettingsRepository([this._settings = AppSettings.initial]);

  AppSettings _settings;

  /// Cantidad de veces que se guardaron preferencias.
  int saveCount = 0;

  @override
  Future<AppSettings> load() async => _settings;

  @override
  Future<void> save(AppSettings settings) async {
    _settings = settings;
    saveCount++;
  }
}
