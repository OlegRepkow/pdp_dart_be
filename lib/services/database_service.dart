import 'package:postgres/postgres.dart';
import '../config/app_config.dart';

abstract class IDatabaseService {
  Future<void> connect();
  Future<void> createTables();
  Connection get connection;
  Future<void> close();
}

class DatabaseService implements IDatabaseService {
  static DatabaseService? _instance;
  Connection? _connection;
  final AppConfig _config = AppConfig.instance;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  @override
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

  Future<void> _createThemesTable() async {
    if (_connection == null) throw Exception('Database not connected');

    try {
      // Створюємо таблицю themes якщо вона не існує
      await _connection!.execute('''
        CREATE TABLE IF NOT EXISTS themes (
          mode VARCHAR(10) PRIMARY KEY,
          data JSONB NOT NULL
        );
      ''');
      print('Themes table ready');
    } catch (e) {
      print('Failed to create themes table: $e');
      rethrow;
    }
  }

  @override
  Future<void> createTables() async {
    if (_connection == null) throw Exception('Database not connected');

    try {
      // Створюємо таблицю themes
      await _createThemesTable();

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

  @override
  Connection get connection {
    if (_connection == null) throw Exception('Database not connected');
    return _connection!;
  }

  @override
  Future<void> close() async {
    await _connection?.close();
  }
}
