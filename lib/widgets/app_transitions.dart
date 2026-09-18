import 'package:flutter/material.dart';

/// Transiciones compartidas entre pantallas.
class AppTransitions {
  const AppTransitions._();

  /// Ruta con desvanecido y un desplazamiento vertical muy corto.
  ///
  /// Resulta mas suave que la animacion por defecto y mantiene el gesto de
  /// retroceso del sistema.
  static Route<T> fade<T>(WidgetBuilder builder) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, animation, secondary) => builder(context),
      transitionsBuilder: _build,
    );
  }

  static Widget _build(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.035),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
