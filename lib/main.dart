import 'package:flutter/material.dart';

import 'app.dart';
import 'services/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Las preferencias se leen antes de pintar para evitar un parpadeo de tema.
  await settingsController.load();
  runApp(const EconautaApp());
}
