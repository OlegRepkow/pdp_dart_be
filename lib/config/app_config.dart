import 'dart:io';

class AppConfig {
  static AppConfig? _instance;

  AppConfig._();

  static AppConfig get instance {
    _instance ??= AppConfig._();
    return _instance!;
  }

  // Server configuration
  String get host => Platform.environment['HOST'] ?? '0.0.0.0';
  int get port => int.parse(Platform.environment['PORT'] ?? '8080');

  // Database configuration
  String get dbHost => Platform.environment['DB_HOST'] ?? 'localhost';
  int get dbPort => int.parse(Platform.environment['DB_PORT'] ?? '5432');
  String get dbName => Platform.environment['DB_NAME'] ?? 'postgres';
  String get dbUser =>
      Platform.environment['DB_USER'] ??
      Platform.environment['USER'] ??
      'postgres';
  String get dbPassword => Platform.environment['DB_PASSWORD'] ?? '';

  // Application configuration
  String get environment =>
      Platform.environment['ENVIRONMENT'] ?? 'development';
  bool get isDevelopment => environment == 'development';
  bool get isProduction => environment == 'production';

  // CORS configuration
  List<String> get allowedOrigins {
    final origins = Platform.environment['ALLOWED_ORIGINS'];
    if (origins == null) return ['*'];
    return origins.split(',').map((e) => e.trim()).toList();
  }

  // Logging configuration
  String get logLevel => Platform.environment['LOG_LEVEL'] ?? 'info';
  bool get enableRequestLogging =>
      Platform.environment['ENABLE_REQUEST_LOGGING'] != 'false';
}
