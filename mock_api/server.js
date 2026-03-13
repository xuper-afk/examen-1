#!/usr/bin/env node
// mock_api/server.js
//
// Servidor API mock para el Laboratorio Integrador N.01 - SIS048
// Universidad Andina del Cusco | Desarrollo de Software II 2026-I
//
// INSTRUCCIONES
// ─────────────────────────────────────────────────────────────────
//  1. Tener Node.js instalado (v16 o superior)
//  2. Ejecutar en terminal (desde la carpeta mock_api/):
//       node server.js
//     O si prefieres usar json-server:
//       npx json-server --watch db.json --port 3000
//  3. El servidor quedará disponible en:
//       http://localhost:3000/students    ← desde el PC del docente
//       http://10.0.2.2:3000/students    ← desde el emulador Android
//       http://localhost:3000/students    ← desde iOS Simulator
// ─────────────────────────────────────────────────────────────────
//
// ENDPOINTS DISPONIBLES:
//   GET  /students          → Lista todos los estudiantes
//   GET  /students/:id      → Obtiene un estudiante por ID
//   POST /students          → Crea un estudiante (no requerido en lab)
//
// Para instalar dependencias (solo si usas este archivo directamente):
//   npm install

const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const DB_PATH = path.join(__dirname, 'db.json');
const PORT = 3000;

function readDb() {
  const raw = fs.readFileSync(DB_PATH, 'utf-8');
  return JSON.parse(raw);
}

function sendJson(res, statusCode, data) {
  const body = JSON.stringify(data, null, 2);
  res.writeHead(statusCode, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Content-Length': Buffer.byteLength(body),
  });
  res.end(body);
}

const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const pathname = parsedUrl.pathname;

  // CORS preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(204, { 'Access-Control-Allow-Origin': '*' });
    res.end();
    return;
  }

  console.log(`[${new Date().toISOString()}] ${req.method} ${pathname}`);

  const db = readDb();

  // GET /students → lista completa
  if (req.method === 'GET' && pathname === '/students') {
    sendJson(res, 200, db.students);
    return;
  }

  // GET /students/:id → estudiante individual
  const matchDetail = pathname.match(/^\/students\/(.+)$/);
  if (req.method === 'GET' && matchDetail) {
    const id = decodeURIComponent(matchDetail[1]);
    const student = db.students.find((s) => s.id === id);
    if (student) {
      sendJson(res, 200, student);
    } else {
      sendJson(res, 404, { error: `Estudiante con id '${id}' no encontrado.` });
    }
    return;
  }

  // GET / → health check
  if (req.method === 'GET' && pathname === '/') {
    sendJson(res, 200, {
      status: 'ok',
      message: 'API Mock - Directorio UAC | SIS048 Lab01',
      endpoints: ['GET /students', 'GET /students/:id'],
      studentCount: db.students.length,
    });
    return;
  }

  // Ruta no encontrada
  sendJson(res, 404, { error: 'Ruta no encontrada.' });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log('');
  console.log('╔══════════════════════════════════════════════════╗');
  console.log('║   API Mock - Directorio UAC | SIS048 Lab01       ║');
  console.log('╠══════════════════════════════════════════════════╣');
  console.log(`║   Servidor corriendo en puerto: ${PORT}               ║`);
  console.log('║                                                  ║');
  console.log('║   Endpoints:                                     ║');
  console.log(`║   • http://localhost:${PORT}/students              ║`);
  console.log(`║   • http://10.0.2.2:${PORT}/students  (emulador)  ║`);
  console.log('║                                                  ║');
  console.log('║   Presiona Ctrl+C para detener el servidor.      ║');
  console.log('╚══════════════════════════════════════════════════╝');
  console.log('');
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`\n❌ El puerto ${PORT} ya está en uso.`);
    console.error(`   Solución: cierra el proceso que usa el puerto ${PORT} o cambia PORT en server.js\n`);
  } else {
    console.error('Error del servidor:', err);
  }
  process.exit(1);
});
