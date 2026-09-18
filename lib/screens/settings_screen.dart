import 'package:flutter/material.dart';

import '../models/app_info.dart';
import '../services/feedback_service.dart';
import '../services/settings_controller.dart';
import '../widgets/app_theme.dart';
import '../widgets/educational_notice.dart';
import '../widgets/screen_scaffold.dart';

/// Pantalla independiente de Configuracion.
///
/// Reune las preferencias de experiencia, la apariencia y la informacion del
/// proyecto. Se abre desde el engranaje de la pantalla principal.
class SettingsScreen extends StatelessWidget {
  /// Crea la pantalla de configuracion.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return ScreenScaffold(
          title: 'Configuracion',
          children: <Widget>[
            SectionCard(
              title: 'Experiencia',
              subtitle: 'Sonido y vibracion durante la practica',
              // ListTile pinta su tinta sobre el Material mas cercano: sin
              // este envoltorio quedaria oculta por el fondo de la tarjeta.
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  children: <Widget>[
                    SwitchListTile.adaptive(
                      value: settingsController.soundEnabled,
                      onChanged: _setSound,
                      title: const Text('Sonidos'),
                      subtitle: const Text(
                        'Efectos cortos al pulsar y al completar actividades',
                      ),
                      secondary: const Icon(Icons.volume_up_outlined),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile.adaptive(
                      value: settingsController.hapticsEnabled,
                      onChanged: _setHaptics,
                      title: const Text('Vibracion'),
                      subtitle: const Text(
                        'Respuesta tactil al pulsar, acertar o fallar',
                      ),
                      secondary: const Icon(Icons.vibration),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Apariencia',
              subtitle: 'Tema de la aplicacion',
              child: _ThemeSelector(mode: settingsController.themeMode),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Informacion',
              subtitle: '${AppInfo.name} ${AppInfo.version}',
              child: const _AboutSection(),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _restoreDefaults,
              icon: const Icon(Icons.settings_backup_restore),
              label: const Text('Restaurar valores por defecto'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 16),
            const EducationalNotice(),
          ],
        );
      },
    );
  }

  Future<void> _setSound(bool value) async {
    await settingsController.setSoundEnabled(value);
    if (value) {
      // Suena una vez para que el estudiante escuche el resultado.
      feedback.confirm();
    }
  }

  Future<void> _setHaptics(bool value) async {
    await settingsController.setHapticsEnabled(value);
    if (value) {
      feedback.vibrate(AppHaptic.success);
    }
  }

  Future<void> _restoreDefaults() async {
    await settingsController.restoreDefaults();
    feedback.confirm();
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.mode});

  final ThemeMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            segments: const <ButtonSegment<ThemeMode>>[
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('Claro'),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('Oscuro'),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('Sistema'),
              ),
            ],
            selected: <ThemeMode>{mode},
            showSelectedIcon: false,
            onSelectionChanged: _onChanged,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _describe(mode),
          style: theme.textTheme.bodySmall?.copyWith(color: colors.muted),
        ),
      ],
    );
  }

  Future<void> _onChanged(Set<ThemeMode> values) async {
    if (values.isEmpty) {
      return;
    }
    await settingsController.setThemeMode(values.first);
    feedback.tap();
  }

  static String _describe(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'La aplicacion se mantiene siempre en modo claro.';
      case ThemeMode.dark:
        return 'La aplicacion se mantiene siempre en modo oscuro.';
      case ThemeMode.system:
        return 'La aplicacion sigue el tema configurado en el telefono.';
    }
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        _InfoRow(label: 'Version', value: AppInfo.version),
        SizedBox(height: 10),
        _InfoRow(label: 'Proyecto', value: AppInfo.description),
        SizedBox(height: 10),
        _InfoRow(label: 'Creditos', value: AppInfo.credits),
        SizedBox(height: 10),
        _InfoRow(label: 'Repositorio', value: AppInfo.repository),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(color: colors.muted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(color: colors.heading),
        ),
      ],
    );
  }
}
