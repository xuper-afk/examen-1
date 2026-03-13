// lib/main.dart
//
// Punto de entrada de la aplicación Directorio de Estudiantes UAC.
// Configura el tema y conecta go_router como sistema de navegación.

import 'package:flutter/material.dart';
import 'router/app_router.dart';

void main() {
  runApp(const DirectorioUACApp());
}

class DirectorioUACApp extends StatelessWidget {
  const DirectorioUACApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Directorio UAC',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A3A5C),
          primary: const Color(0xFF1A3A5C),
          secondary: const Color(0xFF2E75B6),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
