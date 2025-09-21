import 'package:postgres/postgres.dart';
import '../config/app_config.dart';

class DatabaseService {
  static DatabaseService? _instance;
  Connection? _connection;
  final AppConfig _config = AppConfig.instance;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<void> connect() async {
    try {
      _connection = await Connection.open(
        Endpoint(
          host: _config.dbHost,
          port: _config.dbPort,
          database: _config.dbName,
          username: _config.dbUser,
          password: _config.dbPassword,
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );

      print('Connected to PostgreSQL at ${_config.dbHost}:${_config.dbPort}');
    } catch (e) {
      print('Failed to connect to PostgreSQL: $e');
      rethrow;
    }
  }

  Future<void> createTables() async {
    if (_connection == null) throw Exception('Database not connected');

    try {
      // Створюємо таблицю користувачів
      await _connection!.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id VARCHAR(64) PRIMARY KEY,
          username VARCHAR(50) UNIQUE NOT NULL,
          email VARCHAR(100) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // Створюємо таблицю todos з посиланням на користувача
      await _connection!.execute('''
        CREATE TABLE IF NOT EXISTS todos (
          id SERIAL PRIMARY KEY,
          user_id VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          title VARCHAR(255) NOT NULL,
          description TEXT,
          is_completed BOOLEAN DEFAULT FALSE,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      print('Database tables created successfully');
    } catch (e) {
      print('Failed to create database tables: $e');
      rethrow;
    }
  }

  Connection get connection {
    if (_connection == null) throw Exception('Database not connected');
    return _connection!;
  }

  Future<void> close() async {
    await _connection?.close();
  }
}
