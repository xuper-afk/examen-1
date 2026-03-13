// lib/screens/add_student_screen.dart
//
// Pantalla de registro de un nuevo estudiante.
// Implementa el formulario con validaciones de negocio.
//
// ════════════════════════════════════════════════════════
//  🐛 BUG #3 CORREGIDO
//  Error: Falta de dispose() en los TextEditingController
//  Corrección: Implementado dispose() liberando todos los controllers
// ════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/student.dart';
import '../services/student_store.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  // ✅ CORRECTO: GlobalKey declarada como variable de instancia
  final _formKey = GlobalKey<FormState>();

  // Controllers para capturar el texto de cada campo
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _cycleController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Los controllers ya están inicializados como variables de instancia.
    // initState() es el lugar correcto para inicializaciones adicionales
  }

  //  CORREGIDO: Implementación correcta de dispose()
  @override
  void dispose() {
    // Liberar todos los TextEditingController para evitar memory leaks
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _cycleController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);

    final newStudent = Student(
      id: _idController.text.trim(),
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      cycle: int.parse(_cycleController.text.trim()),
    );

    StudentStore.instance.addStudent(newStudent);

    // Limpiar campos después de guardar
    _nameController.clear();
    _idController.clear();
    _emailController.clear();
    _cycleController.clear();

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${newStudent.fullName} registrado correctamente.'),
        backgroundColor: const Color(0xFF1A3A5C),
        behavior: SnackBarBehavior.floating,
      ),
    );

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Registrar Estudiante',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A3A5C),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
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
                // ── Encabezado ──────────────────────────────
                const _FormHeader(),
                const SizedBox(height: 24),

                // ── Campo: Nombre completo ───────────────────
                _buildLabel('Nombre Completo', Icons.person),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    hint: 'Ej. María José Quispe Condori',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre no puede estar vacío';
                    }
                    if (value.trim().length < 5) {
                      return 'El nombre debe tener al menos 5 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ── Campo: Código UAC ─────────────────────────
                _buildLabel('Código UAC', Icons.badge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _idController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: _inputDecoration(
                    hint: 'Ej. UAC-0042',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El código no puede estar vacío';
                    }
                    final regex = RegExp(r'^UAC-\d{4}$');
                    if (!regex.hasMatch(value.trim())) {
                      return 'Formato inválido. Use UAC-XXXX (4 dígitos)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ── Campo: Correo institucional ───────────────
                _buildLabel('Correo Institucional', Icons.email),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                    hint: 'Ej. m.quispe@uandina.edu.pe',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El correo no puede estar vacío';
                    }
                    final regex = RegExp(
                      r'^[\w\.\-]+@uandina\.edu\.pe$',
                      caseSensitive: false,
                    );
                    if (!regex.hasMatch(value.trim())) {
                      return 'Solo se aceptan correos @uandina.edu.pe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ── Campo: Ciclo ──────────────────────────────
                _buildLabel('Ciclo de Estudios', Icons.school),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _cycleController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    hint: 'Número del 1 al 10',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El ciclo no puede estar vacío';
                    }
                    final cycleNum = int.tryParse(value.trim());
                    if (cycleNum == null) {
                      return 'Ingrese un número válido';
                    }
                    if (cycleNum < 1 || cycleNum > 10) {
                      return 'El ciclo debe estar entre 1 y 10';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // ── Botón Registrar ───────────────────────────
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3A5C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _isSubmitting ? 'Registrando...' : 'Registrar Estudiante',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Botón Cancelar ────────────────────────────
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2E75B6)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1A3A5C),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E75B6), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

// ─────────────────────────────────────────────
// Widget: Encabezado del formulario
// ─────────────────────────────────────────────
class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A5C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.person_add_alt_1, color: Colors.white, size: 36),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nuevo Estudiante',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Complete todos los campos con información válida.',
                  style: TextStyle(color: Color(0xAAFFFFFF), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}