// lib/services/student_api_service.dart
//
// Servicio de consumo HTTP para obtener estudiantes desde la API mock.
//
// ════════════════════════════════════════════════════════
//  🐛 ESTE ARCHIVO CONTIENE UN ERROR INTENCIONAL (Bug #1)
//  Tipo: Error de LÓGICA
//  El estudiante debe identificarlo y corregirlo.
// ════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class StudentApiService {
  // Endpoint de la API mock local (json-server)
  static const String _baseUrl = 'http://10.0.2.2:3000';

  /// Obtiene la lista de estudiantes desde la API.
  /// Retorna un [Future<List<Student>>].
  Future<List<Student>> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
      );

      
      if (response.statusCode == 200) {  // ✅ AHORA SÍ: si es exitoso...
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al cargar estudiantes. Código: ${response.statusCode}',
      );
    }
    } catch (e) {
      throw Exception('Fallo de conexión: $e');
    }
  }

  /// Simula el endpoint base para verificar conectividad.
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
