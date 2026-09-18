import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'settings_controller.dart';
import 'sound_player.dart';

/// Efectos de sonido disponibles en la aplicacion.
enum AppSound {
  /// Pulsacion de un boton o de una tarjeta.
  tap,

  /// Confirmacion de una accion aplicada.
  confirm,

  /// Actividad completada.
  complete,

  /// Logro desbloqueado.
  achievement,

  /// Respuesta correcta.
  correct,

  /// Respuesta incorrecta.
  incorrect,
}

/// Intensidades de vibracion usadas por la aplicacion.
enum AppHaptic {
  /// Toque suave al pulsar un control.
  light,

  /// Confirmacion de una accion exitosa.
  success,

  /// Aviso de un valor fuera de rango.
  warning,

  /// Error o respuesta incorrecta.
  error,
}

/// Punto unico de sonido y vibracion de la aplicacion.
///
/// Respeta siempre las preferencias del estudiante: si desactiva el sonido o
/// la vibracion en Configuracion, aqui deja de emitirse.
class FeedbackService {
  /// Crea el servicio con las preferencias y el reproductor indicados.
  FeedbackService({required this.settings, required this.player});

  /// Preferencias vigentes del estudiante.
  final SettingsController settings;

  /// Reproductor de los efectos de sonido.
  final SoundPlayer player;

  static const Map<AppSound, String> _assets = <AppSound, String>{
    AppSound.tap: 'audio/tap.wav',
    AppSound.confirm: 'audio/confirm.wav',
    AppSound.complete: 'audio/complete.wav',
    AppSound.achievement: 'audio/achievement.wav',
    AppSound.correct: 'audio/correct.wav',
    AppSound.incorrect: 'audio/incorrect.wav',
  };

  /// Archivo asociado a cada efecto.
  static String assetFor(AppSound sound) => _assets[sound]!;

  /// Reproduce un sonido corto si el estudiante los mantiene activos.
  void playSound(AppSound sound) {
    if (!settings.soundEnabled) {
      return;
    }
    final volume = sound == AppSound.tap ? 0.35 : 0.55;
    unawaited(_play(assetFor(sound), volume));
  }

  /// Ejecuta una vibracion si el estudiante la mantiene activa.
  void vibrate(AppHaptic haptic) {
    if (!settings.hapticsEnabled) {
      return;
    }
    unawaited(_vibrate(haptic));
  }

  /// Pulsacion de un control: sonido muy corto y vibracion suave.
  void tap() {
    playSound(AppSound.tap);
    vibrate(AppHaptic.light);
  }

  /// Accion aplicada correctamente.
  void confirm() {
    playSound(AppSound.confirm);
    vibrate(AppHaptic.success);
  }

  /// Actividad completada.
  void complete() {
    playSound(AppSound.complete);
    vibrate(AppHaptic.success);
  }

  /// Logro desbloqueado.
  void achievement() {
    playSound(AppSound.achievement);
    vibrate(AppHaptic.success);
  }

  /// Respuesta correcta.
  void correct() {
    playSound(AppSound.correct);
    vibrate(AppHaptic.success);
  }

  /// Respuesta incorrecta.
  void incorrect() {
    playSound(AppSound.incorrect);
    vibrate(AppHaptic.error);
  }

  /// Aviso de valores fuera de rango.
  void warning() {
    playSound(AppSound.incorrect);
    vibrate(AppHaptic.warning);
  }

  /// Libera los recursos del reproductor.
  Future<void> dispose() => player.dispose();

  Future<void> _play(String asset, double volume) async {
    try {
      await player.play(asset, volume);
    } catch (error) {
      debugPrint('Econauta: sonido no disponible ($error)');
    }
  }

  Future<void> _vibrate(AppHaptic haptic) async {
    try {
      await switch (haptic) {
        AppHaptic.light => HapticFeedback.selectionClick(),
        AppHaptic.success => HapticFeedback.mediumImpact(),
        AppHaptic.warning => HapticFeedback.vibrate(),
        AppHaptic.error => HapticFeedback.heavyImpact(),
      };
    } catch (error) {
      debugPrint('Econauta: vibracion no disponible ($error)');
    }
  }
}

/// Instancia global usada por las pantallas.
///
/// Las pruebas la reemplazan por una version con [RecordingSoundPlayer].
FeedbackService feedback = FeedbackService(
  settings: settingsController,
  player: AudioPlayersSoundPlayer(),
);
