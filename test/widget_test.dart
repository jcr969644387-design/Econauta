import 'package:econauta/app.dart';
import 'package:econauta/services/app_state.dart';
import 'package:econauta/widgets/module_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Monta la app con un viewport alto.
///
/// La pantalla principal usa un [ListView] perezoso: con el tamano por
/// defecto de las pruebas (800x600) solo se construyen los widgets visibles
/// y los modulos del final quedarian fuera del arbol.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 4000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const EconautaApp());
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    appState.reset();
  });

  testWidgets('la pantalla principal carga y muestra el nombre Econauta', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Econauta'), findsOneWidget);
    expect(find.text('Simulador de politica economica'), findsOneWidget);
    expect(find.text('Panorama del periodo 0'), findsOneWidget);
  });

  testWidgets('aparecen los botones de los modulos', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(ModuleButton), findsNWidgets(8));
    expect(find.text('Inflacion'), findsOneWidget);
    expect(find.text('PIB y crecimiento'), findsOneWidget);
    expect(find.text('Mercado laboral'), findsOneWidget);
    expect(find.text('Politica fiscal'), findsOneWidget);
    expect(find.text('Politica monetaria'), findsOneWidget);
    expect(find.text('Simulacion'), findsOneWidget);
    expect(find.text('Evaluacion'), findsOneWidget);
    expect(find.text('Analista economico'), findsOneWidget);
  });

  testWidgets('el modulo de simulacion se abre y ejecuta periodos', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.ensureVisible(find.text('Simulacion'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulacion'));
    await tester.pumpAndSettle();

    expect(find.text('Periodos a simular'), findsOneWidget);
    expect(find.text('Ejecutar simulacion'), findsOneWidget);

    await tester.tap(find.text('Ejecutar simulacion'));
    await tester.pumpAndSettle();

    expect(appState.current.period, 3);
    expect(appState.history.length, 4);
  });
}
