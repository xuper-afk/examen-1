# flutter_lab01_base — Directorio de Estudiantes UAC

**SIS048 – Desarrollo de Software II | Laboratorio Integrador N.° 01 | 2026-I**
Universidad Andina del Cusco – Facultad de Ingeniería y Arquitectura

---

## 🎯 Descripción

Proyecto base para la evaluación práctica integradora de la Primera Unidad.
El estudiante debe completar la implementación, **identificar y corregir los 3 errores intencionales** (bugs saboteados), y estar preparado para sustentar oralmente sus decisiones arquitectónicas.

---

## ⚙️ Requisitos previos

| Herramienta | Versión mínima |
|---|---|
| Flutter SDK | 3.19.0 |
| Dart SDK | 3.3.0 |
| Node.js | 16.0.0 |
| Android Studio / VS Code | Cualquier versión reciente |
| Emulador Android | API 31+ |

---

## 🚀 Pasos de configuración (OBLIGATORIOS antes de empezar)

### 1. Instalar dependencias Flutter

```bash
flutter pub get
```

### 2. Generar código Freezed

```bash
dart run build_runner build --delete-conflicting-outputs
```

> ⚠️ Este paso es OBLIGATORIO. Sin él, los archivos `.freezed.dart` y `.g.dart` no estarán disponibles y la app no compilará.

### 3. Iniciar la API mock

```bash
cd mock_api
node server.js
```

El servidor quedará disponible en:
- `http://localhost:3000/students` → desde el navegador / iOS Simulator
- `http://10.0.2.2:3000/students` → desde el emulador Android (**ya configurado en el código**)

### 4. Ejecutar la app

```bash
flutter run
```

---

## 📁 Estructura del proyecto

```
flutter_lab01_base/
├── lib/
│   ├── main.dart                    # Punto de entrada
│   ├── models/
│   │   ├── student.dart             # Modelo con @freezed
│   │   ├── student.freezed.dart     # Generado por Freezed
│   │   └── student.g.dart           # Generado por json_serializable
│   ├── services/
│   │   ├── student_api_service.dart # Consumo HTTP  ← 🐛 Bug #1
│   │   └── student_store.dart       # Estado local compartido
│   ├── router/
│   │   └── app_router.dart          # Configuración go_router
│   └── screens/
│       ├── home_screen.dart         # Lista + Layout responsivo ← 🐛 Bug #2
│       ├── add_student_screen.dart  # Formulario de registro    ← 🐛 Bug #3
│       ├── detail_screen.dart       # Perfil del estudiante
│       └── edit_screen.dart         # Edición de datos
├── mock_api/
│   ├── server.js                    # Servidor API mock (Node.js)
│   └── db.json                      # Datos de prueba (8 estudiantes)
├── pubspec.yaml
└── README.md
```

---


## 🗺️ Rutas de la aplicación

| Pantalla | Ruta | Descripción |
|---|---|---|
| HomeScreen | `/home` | Lista todos los estudiantes |
| AddStudentScreen | `/add` | Formulario de registro |
| DetailScreen | `/detail/:id` | Perfil completo |
| EditScreen | `/edit/:id` | Edición de datos |

---

## ✅ Validaciones implementadas

| Campo | Regla |
|---|---|
| Nombre completo | No vacío, mínimo 5 caracteres |
| Código UAC | Regex `^UAC-\d{4}$` (ej. UAC-0042) |
| Correo institucional | Regex `^[\w\.\-]+@uandina\.edu\.pe$` |
| Ciclo | Entero entre 1 y 10 |

---

*Universidad Andina del Cusco — Departamento de Ingeniería de Sistemas — 2026*
