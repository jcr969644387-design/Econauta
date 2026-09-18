import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Boton con forma de tarjeta que abre un modulo educativo.
class ModuleButton extends StatelessWidget {
  const ModuleButton({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  /// Nombre del modulo.
  final String title;

  /// Descripcion corta del modulo.
  final String description;

  /// Icono representativo.
  final IconData icon;

  /// Accion al pulsar el boton.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(14),
        foregroundColor: AppPalette.primaryDark,
        side: const BorderSide(color: AppPalette.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: AppPalette.primary),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppPalette.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppPalette.neutral,
            ),
          ),
        ],
      ),
    );
  }
}
