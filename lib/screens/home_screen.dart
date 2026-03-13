// lib/screens/home_screen.dart
//
// Pantalla principal: muestra la lista combinada de estudiantes
// (locales + obtenidos de la API) usando FutureBuilder y ListView.builder.
// Incluye diseño responsivo con LayoutBuilder.
//
// ════════════════════════════════════════════════════════
//  🐛 BUG #2 CORREGIDO
//  Error: GlobalKey declarada dentro del build()
//  Corrección: Movida como variable de instancia
// ════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/student.dart';
import '../services/student_api_service.dart';
import '../services/student_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Student>> _futureStudents;
  final StudentApiService _apiService = StudentApiService();
  
  //  CORREGIDO: GlobalKey declarada como variable de instancia (FUERA del build)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _futureStudents = _apiService.fetchStudents();
  }

  void _refreshList() {
    setState(() {
      _futureStudents = _apiService.fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    //  ANTES: la GlobalKey estaba aquí (mal)
    // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: _scaffoldKey, // ✅ Usando la key correcta
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Directorio UAC',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A3A5C),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar lista',
            onPressed: _refreshList,
          ),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _futureStudents,
        builder: (context, snapshot) {
          // Estado: cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF2E75B6)),
                  SizedBox(height: 16),
                  Text('Cargando directorio...'),
                ],
              ),
            );
          }

          // Estado: error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No se pudo conectar a la API.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _refreshList,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Estado: datos recibidos
          final apiStudents = snapshot.data ?? [];
          final localStudents = StudentStore.instance.localStudents;
          final allStudents = [...apiStudents, ...localStudents];

          if (allStudents.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay estudiantes registrados.\nPresiona + para agregar uno.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // Layout responsivo: LayoutBuilder detecta el ancho disponible
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                // Pantalla ancha (tablet/desktop): Grid de 2 columnas
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3.0,
                  ),
                  itemCount: allStudents.length,
                  itemBuilder: (context, index) {
                    return _StudentCard(student: allStudents[index]);
                  },
                );
              } else {
                // Pantalla estrecha (móvil): Lista simple
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allStudents.length,
                  itemBuilder: (context, index) {
                    return _StudentCard(student: allStudents[index]);
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        backgroundColor: const Color(0xFF2E75B6),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Nuevo', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Widget reutilizable: Tarjeta de estudiante
// ─────────────────────────────────────────────
class _StudentCard extends StatelessWidget {
  const _StudentCard({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => context.push('/detail/${student.id}'),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1A3A5C),
          child: Text(
            student.fullName.isNotEmpty
                ? student.fullName[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student.id, style: const TextStyle(color: Color(0xFF2E75B6))),
            Text('Ciclo ${student.cycle}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        isThreeLine: true,
      ),
    );
  }
}