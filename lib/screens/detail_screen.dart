// lib/screens/detail_screen.dart
//
// Pantalla de detalle: muestra el perfil completo de un estudiante.
// Recibe el ID del estudiante via go_router pathParameters.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/student.dart';
import '../services/student_store.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context) {
    final student = StudentStore.instance.findById(studentId);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Perfil del Estudiante',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A3A5C),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (student != null)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar',
              onPressed: () => context.push('/edit/$studentId'),
            ),
        ],
      ),
      body: student == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Estudiante no encontrado.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : _StudentProfile(student: student),
    );
  }
}

class _StudentProfile extends StatelessWidget {
  const _StudentProfile({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 56,
            backgroundColor: const Color(0xFF1A3A5C),
            child: Text(
              student.fullName.isNotEmpty
                  ? student.fullName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            student.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A3A5C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2E75B6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              student.id,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 32),
          // Datos
          _InfoCard(
            icon: Icons.email,
            label: 'Correo Institucional',
            value: student.email,
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.school,
            label: 'Ciclo de Estudios',
            value: 'Ciclo ${student.cycle}',
          ),
          if (student.photoUrl != null) ...[
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.image,
              label: 'Foto',
              value: student.photoUrl!,
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/edit/${student.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E75B6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text(
                'Editar Estudiante',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2E75B6)),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A5C),
          ),
        ),
      ),
    );
  }
}
