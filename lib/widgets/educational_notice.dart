import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Aviso permanente sobre el caracter educativo de la simulacion.
class EducationalNotice extends StatelessWidget {
  const EducationalNotice({super.key, this.message});

  /// Texto alternativo del aviso.
  final String? message;

  /// Texto por defecto mostrado en la aplicacion.
  static const String defaultMessage =
      'Simulacion educativa con reglas simplificadas. No es una prediccion '
      'economica ni reemplaza modelos econometricos o analisis profesional.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        border: Border.all(color: const Color(0xFFE8D3A9)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.info_outline, size: 18, color: AppPalette.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? defaultMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppPalette.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta simple con titulo y contenido, usada en todas las pantallas.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  /// Titulo de la seccion.
  final String title;

  /// Subtitulo opcional.
  final String? subtitle;

  /// Contenido de la seccion.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleText = subtitle;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppPalette.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppPalette.primaryDark,
            ),
          ),
          if (subtitleText != null) const SizedBox(height: 4),
          if (subtitleText != null)
            Text(
              subtitleText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppPalette.neutral,
              ),
            ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
