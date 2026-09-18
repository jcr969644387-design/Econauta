import 'package:econauta/models/app_settings.dart';
import 'package:econauta/repositories/settings_repository.dart';
import 'package:econauta/services/feedback_service.dart';
import 'package:econauta/services/settings_controller.dart';
import 'package:econauta/services/sound_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

SettingsController _controller([AppSettings? stored]) {
  return SettingsController(
    repository: InMemorySettingsRepository(stored ?? AppSettings.initial),
  );
}

void main() {
  // La vibracion usa un canal de plataforma, por eso se inicia el binding.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSettings', () {
    test('los valores por defecto activan sonido y vibracion', () {
      const settings = AppSettings.initial;
      expect(settings.soundEnabled, isTrue);
      expect(settings.hapticsEnabled, isTrue);
      expect(settings.themeMode, ThemeMode.system);
    });

    test('copyWith conserva los valores no indicados', () {
      const settings = AppSettings.initial;
      final changed = settings.copyWith(soundEnabled: false);
      expect(changed.soundEnabled, isFalse);
      expect(changed.hapticsEnabled, isTrue);
      expect(changed.themeMode, ThemeMode.system);
      expect(changed, isNot(settings));
      expect(changed.copyWith(soundEnabled: true), settings);
    });
  });

  group('SettingsRepository', () {
    test('guarda y recupera las preferencias', () async {
      final repository = InMemorySettingsRepository();
      const stored = AppSettings(
        soundEnabled: false,
        hapticsEnabled: false,
        themeMode: ThemeMode.dark,
      );
      await repository.save(stored);
      expect(await repository.load(), stored);
      expect(repository.saveCount, 1);
    });

    test('un tema desconocido vuelve al del sistema', () {
      expect(
        PreferencesSettingsRepository.decodeThemeMode('dark'),
        ThemeMode.dark,
      );
      expect(
        PreferencesSettingsRepository.decodeThemeMode('otro'),
        ThemeMode.system,
      );
      expect(
        PreferencesSettingsRepository.decodeThemeMode(null),
        ThemeMode.system,
      );
    });
  });

  group('SettingsController', () {
    test('parte de los valores por defecto', () {
      final controller = _controller();
      expect(controller.soundEnabled, isTrue);
      expect(controller.hapticsEnabled, isTrue);
      expect(controller.themeMode, ThemeMode.system);
      expect(controller.isLoaded, isFalse);
    });

    test('lee las preferencias guardadas', () async {
      const stored = AppSettings(
        soundEnabled: false,
        hapticsEnabled: false,
        themeMode: ThemeMode.dark,
      );
      final controller = _controller(stored);
      await controller.load();
      expect(controller.isLoaded, isTrue);
      expect(controller.soundEnabled, isFalse);
      expect(controller.hapticsEnabled, isFalse);
      expect(controller.themeMode, ThemeMode.dark);
    });

    test('no vuelve a guardar un valor que no cambio', () async {
      final repository = InMemorySettingsRepository();
      final controller = SettingsController(repository: repository);
      await controller.setSoundEnabled(false);
      await controller.setSoundEnabled(false);
      expect(controller.soundEnabled, isFalse);
      expect(repository.saveCount, 1);
    });

    test('avisa a la interfaz en cada cambio', () async {
      final controller = _controller();
      var notifications = 0;
      controller.addListener(() {
        notifications++;
      });
      await controller.setThemeMode(ThemeMode.dark);
      await controller.setHapticsEnabled(false);
      expect(notifications, 2);
    });

    test('restaura los valores por defecto', () async {
      final controller = _controller();
      await controller.setSoundEnabled(false);
      await controller.setThemeMode(ThemeMode.light);
      await controller.restoreDefaults();
      expect(controller.settings, AppSettings.initial);
    });
  });

  group('FeedbackService', () {
    test('reproduce el sonido de cada accion', () {
      final player = RecordingSoundPlayer();
      final service = FeedbackService(
        settings: _controller(),
        player: player,
      );
      service.tap();
      service.complete();
      service.achievement();
      expect(player.played, <String>[
        FeedbackService.assetFor(AppSound.tap),
        FeedbackService.assetFor(AppSound.complete),
        FeedbackService.assetFor(AppSound.achievement),
      ]);
    });

    test('queda en silencio si el estudiante desactiva el sonido', () async {
      final player = RecordingSoundPlayer();
      final controller = _controller();
      await controller.setSoundEnabled(false);
      final service = FeedbackService(
        settings: controller,
        player: player,
      );
      service.tap();
      service.incorrect();
      service.warning();
      expect(player.played, isEmpty);
    });

    test('cada efecto tiene su archivo de audio', () {
      for (final sound in AppSound.values) {
        expect(FeedbackService.assetFor(sound), startsWith('audio/'));
        expect(FeedbackService.assetFor(sound), endsWith('.wav'));
      }
    });
  });
}
