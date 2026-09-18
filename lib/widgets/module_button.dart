import 'package:flutter/material.dart';

import '../services/feedback_service.dart';
import 'app_theme.dart';

/// Boton con forma de tarjeta que abre un modulo educativo.
///
/// Al pulsarlo se encoge levemente y emite sonido y vibracion, de modo que
/// la respuesta al toque se sienta inmediata.
class ModuleButton extends StatefulWidget {
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
  State<ModuleButton> createState() => _ModuleButtonState();
}

class _ModuleButtonState extends State<ModuleButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() {
      _pressed = value;
    });
  }

  void _handlePressed() {
    feedback.tap();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    return Listener(
      // Listener no compite en la arena de gestos, asi que el efecto de
      // pulsado funciona sin interferir con el toque del boton.
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: OutlinedButton(
          onPressed: _handlePressed,
          style: OutlinedButton.styleFrom(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(14),
            foregroundColor: colors.heading,
            backgroundColor: colors.cardSurface,
            side: BorderSide(color: colors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(widget.icon, color: colors.accent),
              const SizedBox(height: 10),
              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.heading,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
