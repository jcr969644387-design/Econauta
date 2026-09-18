import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/settings_controller.dart';
import 'widgets/app_theme.dart';

/// Widget raiz de Econauta.
class EconautaApp extends StatelessWidget {
  const EconautaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Econauta',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settingsController.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
