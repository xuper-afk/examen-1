// lib/services/student_store.dart
//
// Almacén compartido de estudiantes locales (en memoria).
// Actúa como fuente de verdad para las pantallas de detalle y edición.
// En una app real, esto sería reemplazado por un gestor de estado (Riverpod, BLoC).

import '../models/student.dart';

class StudentStore {
  StudentStore._();
  static final StudentStore instance = StudentStore._();

  // Lista mutable de estudiantes locales (agregados en la app)
  final List<Student> _localStudents = [];

  List<Student> get localStudents => List.unmodifiable(_localStudents);

  void addStudent(Student student) {
    _localStudents.add(student);
  }

  void updateStudent(Student updated) {
    final index = _localStudents.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _localStudents[index] = updated;
    }
  }

  Student? findById(String id) {
    try {
      return _localStudents.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
