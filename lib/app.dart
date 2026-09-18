import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'widgets/app_palette.dart';

/// Widget raiz de Econauta.
class EconautaApp extends StatelessWidget {
  const EconautaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: AppPalette.primary);
    return MaterialApp(
      title: 'Econauta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppPalette.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
