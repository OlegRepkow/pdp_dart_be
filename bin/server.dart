import 'dart:io';

import 'package:pdp_dart_be/routes/api_routes_generated.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:pdp_dart_be/services/database_service.dart';
import 'package:pdp_dart_be/config/app_config.dart';
import 'package:pdp_dart_be/middleware/auth_middleware.dart';

void main(List<String> args) async {
  final config = AppConfig.instance;

  print('Starting Todo Backend Server...');
  print('Environment: ${config.environment}');

  try {
    // Підключення до бази даних
    await DatabaseService.instance.connect();
    await DatabaseService.instance.createTables();

    print('Database connection established');
  } catch (e) {
    print('Failed to connect to database: $e');
    exit(1);
  }

  // Налаштування маршрутів
  final apiRoutes = ApiRoutes();
  final router = Router();

  // Додаємо API маршрути
  router.mount('/api/', apiRoutes.router);

  // Корінь сервера
  router.get('/', (Request request) {
    return Response.ok(
        'Todo Backend API v1.0.0\n\nAvailable endpoints:\n- GET /api/health\n- POST /api/auth/register\n- POST /api/auth/login\n- GET /api/auth/profile\n- PUT /api/auth/profile\n- GET /api/todos/all\n- GET /api/todos/user/{userId}\n- POST /api/todos/create\n- GET /api/todos/get/{id}\n- PUT /api/todos/update/{id}\n- DELETE /api/todos/delete/{id}\n\nEnvironment: ${config.environment}');
  });

  // Налаштування CORS та логування
  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addMiddleware(AuthMiddleware.extractUser())
      .addHandler(router);

  // Запуск сервера
  final ip = InternetAddress.anyIPv4;
  final server = await serve(handler, ip, config.port);

  print('🚀 Todo Backend Server started!');
  print('📍 Server listening on ${config.host}:${server.port}');
  print('🔗 Health check: http://${config.host}:${server.port}/api/health');
  print('📝 Todos API: http://${config.host}:${server.port}/api/todos');
}
