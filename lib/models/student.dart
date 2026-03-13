// lib/models/student.dart
//
// Modelo principal de datos: Student
// Generado con Freezed para garantizar inmutabilidad.
//
// INSTRUCCIÓN PARA EL ESTUDIANTE:
// Ejecutar: dart run build_runner build --delete-conflicting-outputs
// Esto generará el archivo student.freezed.dart y student.g.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
class Student with _$Student {
  const factory Student({
    required String id,
    required String fullName,
    required String email,
    required int cycle,
    String? photoUrl,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
