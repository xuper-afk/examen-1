// lib/router/app_router.dart
//
// Configuración de navegación declarativa con go_router.
// Define las 4 rutas principales de la aplicación.

import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/add_student_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/edit_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddStudentScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final studentId = state.pathParameters['id']!;
        return DetailScreen(studentId: studentId);
      },
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
        final studentId = state.pathParameters['id']!;
        return EditScreen(studentId: studentId);
      },
    ),
  ],
);
