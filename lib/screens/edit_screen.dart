// lib/screens/edit_screen.dart
//
// Pantalla de edición: reutiliza la lógica del formulario con datos pre-cargados.
// Recibe el ID del estudiante via go_router y busca sus datos en StudentStore.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/student.dart';
import '../services/student_store.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.studentId});

  final String studentId;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // ✅ GlobalKey correctamente ubicada como variable de instancia
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _idController;
  late final TextEditingController _emailController;
  late final TextEditingController _cycleController;

  Student? _originalStudent;

  @override
  void initState() {
    super.initState();
    _originalStudent = StudentStore.instance.findById(widget.studentId);

    // Pre-cargar los datos actuales del estudiante en los controllers
    _nameController = TextEditingController(
      text: _originalStudent?.fullName ?? '',
    );
    _idController = TextEditingController(
      text: _originalStudent?.id ?? '',
    );
    _emailController = TextEditingController(
      text: _originalStudent?.email ?? '',
    );
    _cycleController = TextEditingController(
      text: _originalStudent?.cycle.toString() ?? '',
    );
  }

  @override
  void dispose() {
    // ✅ CORRECTO: Liberando todos los controllers para evitar memory leaks
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _cycleController.dispose();
    super.dispose();
  }

  void _submitEdit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final updatedStudent = Student(
      id: _idController.text.trim(),
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      cycle: int.parse(_cycleController.text.trim()),
      photoUrl: _originalStudent?.photoUrl,
    );

    StudentStore.instance.updateStudent(updatedStudent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Datos actualizados correctamente.'),
        backgroundColor: Color(0xFF1A3A5C),
        behavior: SnackBarBehavior.floating,
      ),
    );

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    if (_originalStudent == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Estudiante',
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF1A3A5C),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: Text('Estudiante no encontrado.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Editar Estudiante',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A3A5C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ CORREGIDO: withOpacity(0.1) → withValues(alpha: 0.1)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E75B6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2E75B6)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF2E75B6)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Editando: ${_originalStudent!.id}',
                          style: const TextStyle(
                            color: Color(0xFF1A3A5C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildField(
                  label: 'Nombre Completo',
                  icon: Icons.person,
                  controller: _nameController,
                  validator: (v) {
                    if (v == null || v.trim().length < 5) {
                      return 'El nombre debe tener al menos 5 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildField(
                  label: 'Código UAC',
                  icon: Icons.badge,
                  controller: _idController,
                  validator: (v) {
                    if (!RegExp(r'^UAC-\d{4}$').hasMatch(v?.trim() ?? '')) {
                      return 'Formato inválido. Use UAC-XXXX (4 dígitos)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildField(
                  label: 'Correo Institucional',
                  icon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (!RegExp(r'^[\w\.\-]+@uandina\.edu\.pe$',
                            caseSensitive: false)
                        .hasMatch(v?.trim() ?? '')) {
                      return 'Solo se aceptan correos @uandina.edu.pe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildField(
                  label: 'Ciclo',
                  icon: Icons.school,
                  controller: _cycleController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final n = int.tryParse(v?.trim() ?? '');
                    if (n == null || n < 1 || n > 10) {
                      return 'El ciclo debe estar entre 1 y 10';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _submitEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3A5C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Guardar Cambios',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF2E75B6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1A3A5C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF2E75B6), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}