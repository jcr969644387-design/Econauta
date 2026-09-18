import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';

/// Expone las preferencias a la interfaz y las guarda en el repositorio.
///
/// Cumple el papel de ViewModel de la pantalla de Configuracion.
class SettingsController extends ChangeNotifier {
  /// Crea el controlador con el repositorio indicado.
  SettingsController({SettingsRepository? repository})
      : _repository = repository ?? PreferencesSettingsRepository();

  final SettingsRepository _repository;

  AppSettings _settings = AppSettings.initial;
  bool _loaded = false;

  /// Preferencias vigentes.
  AppSettings get settings => _settings;

  /// Indica si ya se leyeron las preferencias guardadas.
  bool get isLoaded => _loaded;

  /// Indica si los sonidos estan activos.
  bool get soundEnabled => _settings.soundEnabled;

  /// Indica si la vibracion esta activa.
  bool get hapticsEnabled => _settings.hapticsEnabled;

  /// Tema seleccionado por el estudiante.
  ThemeMode get themeMode => _settings.themeMode;

  /// Lee las preferencias guardadas al iniciar la aplicacion.
  Future<void> load() async {
    try {
      // Un almacenamiento que no responde no debe bloquear el arranque.
      const limit = Duration(seconds: 3);
      _settings = await _repository.load().timeout(limit);
    } catch (error) {
      debugPrint('Econauta: preferencias no disponibles ($error)');
      _settings = AppSettings.initial;
    }
    _loaded = true;
    notifyListeners();
  }

  /// Activa o desactiva los efectos de sonido.
  Future<void> setSoundEnabled(bool value) {
    return _update(_settings.copyWith(soundEnabled: value));
  }

  /// Activa o desactiva la vibracion.
  Future<void> setHapticsEnabled(bool value) {
    return _update(_settings.copyWith(hapticsEnabled: value));
  }

  /// Cambia el tema de la aplicacion.
  Future<void> setThemeMode(ThemeMode value) {
    return _update(_settings.copyWith(themeMode: value));
  }

  /// Vuelve a los valores por defecto.
  Future<void> restoreDefaults() => _update(AppSettings.initial);

  Future<void> _update(AppSettings next) async {
    if (next == _settings) {
      return;
    }
    _settings = next;
    notifyListeners();
    try {
      await _repository.save(next);
    } catch (error) {
      debugPrint('Econauta: no se pudieron guardar las preferencias ($error)');
    }
  }
}

/// Instancia global usada por las pantallas del MVP.
///
/// Las pruebas la reemplazan por una con [InMemorySettingsRepository], para
/// no depender del almacenamiento nativo del telefono.
SettingsController settingsController = SettingsController();
