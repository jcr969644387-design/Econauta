import 'package:econauta/app.dart';
import 'package:econauta/services/app_state.dart';
import 'package:econauta/services/feedback_service.dart';
import 'package:econauta/services/settings_controller.dart';
import 'package:econauta/services/sound_player.dart';
import 'package:econauta/widgets/module_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reproductor que anota los sonidos pedidos durante cada prueba.
late RecordingSoundPlayer sounds;

/// Busca el titulo de un modulo dentro de su [ModuleButton].
///
/// Algunos titulos ('Inflacion') tambien aparecen como indicadores del
/// panorama, asi que buscarlos por texto suelto encontraria dos widgets.
Finder moduleTitled(String title) {
  return find.descendant(
    of: find.byType(ModuleButton),
    matching: find.text(title),
  );
}

void main() {
  setUp(() async {
    appState.reset();
    await settingsController.restoreDefaults();
    sounds = RecordingSoundPlayer();
    feedback = FeedbackService(settings: settingsController, player: sounds);
  });

  testWidgets('la pantalla principal carga y muestra el nombre Econauta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EconautaApp());
    await tester.pumpAndSettle();

    expect(find.text('Econauta'), findsOneWidget);
    expect(find.text('Simulador de politica economica'), findsOneWidget);
    expect(find.text('Panorama del periodo 0'), findsOneWidget);
  });

  testWidgets('aparecen los botones de los modulos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EconautaApp());
    await tester.pumpAndSettle();

    expect(find.byType(ModuleButton), findsNWidgets(8));
    expect(moduleTitled('Inflacion'), findsOneWidget);
    expect(moduleTitled('PIB y crecimiento'), findsOneWidget);
    expect(moduleTitled('Mercado laboral'), findsOneWidget);
    expect(moduleTitled('Politica fiscal'), findsOneWidget);
    expect(moduleTitled('Politica monetaria'), findsOneWidget);
    expect(moduleTitled('Simulacion'), findsOneWidget);
    expect(moduleTitled('Evaluacion'), findsOneWidget);
    expect(moduleTitled('Analista economico'), findsOneWidget);
  });

  testWidgets('el contenido respeta el area segura del telefono', (
    WidgetTester tester,
  ) async {
    // Se simula un telefono con notch arriba y barra de gestos abajo.
    tester.view.viewPadding = const FakeViewPadding(top: 141, bottom: 105);
    tester.view.padding = const FakeViewPadding(top: 141, bottom: 105);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const EconautaApp());
    await tester.pumpAndSettle();

    final viewPadding = tester.view.viewPadding;
    final ratio = tester.view.devicePixelRatio;
    final bottomInset = viewPadding.bottom / ratio;
    final topInset = viewPadding.top / ratio;

    // El encabezado arranca por debajo del notch.
    final header = tester.getTopLeft(
      find.text('Simulador de politica economica'),
    );
    expect(header.dy, greaterThan(topInset));

    // La lista reserva al menos el alto de la barra de gestos al final.
    final listView = tester.widget<ListView>(find.byType(ListView).first);
    final padding = listView.padding as EdgeInsets?;
    expect(padding, isNotNull);
    expect(padding!.bottom, greaterThanOrEqualTo(bottomInset));
  });

  testWidgets('el engranaje abre la pantalla de Configuracion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EconautaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Configuracion'), findsOneWidget);
    expect(find.text('Sonidos'), findsOneWidget);
    expect(find.text('Vibracion'), findsOneWidget);
    expect(find.text('V1.0.2'), findsOneWidget);
  });

  testWidgets('desactivar el sonido silencia la aplicacion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EconautaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sonidos'));
    await tester.pumpAndSettle();
    expect(settingsController.soundEnabled, isFalse);

    sounds.played.clear();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(moduleTitled('Evaluacion'));
    await tester.pumpAndSettle();
    await tester.tap(moduleTitled('Evaluacion'));
    await tester.pumpAndSettle();

    expect(find.text('Revisar respuestas'), findsOneWidget);
    expect(sounds.played, isEmpty);
  });

  testWidgets('pulsar un modulo suena y abre la pantalla', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EconautaApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(moduleTitled('Evaluacion'));
    await tester.pumpAndSettle();
    await tester.tap(moduleTitled('Evaluacion'));
    await tester.pumpAndSettle();

    expect(find.text('Revisar respuestas'), findsOneWidget);
    expect(sounds.played, contains(FeedbackService.assetFor(AppSound.tap)));
  });

  testWidgets('el modulo de simulacion se abre y ejecuta periodos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EconautaApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(moduleTitled('Simulacion'));
    await tester.pumpAndSettle();
    await tester.tap(moduleTitled('Simulacion'));
    await tester.pumpAndSettle();

    expect(find.text('Periodos a simular'), findsOneWidget);
    expect(find.text('Ejecutar simulacion'), findsOneWidget);

    await tester.tap(find.text('Ejecutar simulacion'));
    await tester.pumpAndSettle();

    expect(appState.current.period, 3);
    expect(appState.history.length, 4);
    expect(
      sounds.played,
      contains(FeedbackService.assetFor(AppSound.complete)),
    );
  });
}
