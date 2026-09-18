import 'package:flutter/material.dart';

/// Pantalla base de Econauta con area segura uniforme.
///
/// Centraliza el respeto al notch, a la Dynamic Island, a la barra inferior
/// de navegacion y a la zona de gestos del sistema, para que ninguna pantalla
/// tenga que resolverlo por su cuenta y todas compartan el mismo margen.
class ScreenScaffold extends StatelessWidget {
  /// Crea la pantalla con el titulo y el contenido indicados.
  const ScreenScaffold({
    super.key,
    required this.title,
    required this.children,
    this.actions,
  });

  /// Margen compartido por todas las pantallas.
  static const double gutter = 16;

  /// Espacio extra al final del contenido desplazable.
  static const double bottomGap = 8;

  /// Titulo mostrado en la barra superior.
  final String title;

  /// Acciones opcionales de la barra superior.
  final List<Widget>? actions;

  /// Contenido desplazable de la pantalla.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // viewPadding conserva el inset fisico del dispositivo aunque algun
    // widget intermedio haya consumido el padding logico.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(
        // La barra superior ya resuelve el notch; el margen inferior se
        // aplica como padding para que el contenido siga desplazandose
        // por debajo de la zona de gestos en lugar de quedar recortado.
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            gutter,
            gutter,
            gutter,
            gutter + bottomGap + bottomInset,
          ),
          children: children,
        ),
      ),
    );
  }
}
