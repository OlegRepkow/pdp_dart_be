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
      await _connection!.execute('''
        CREATE TABLE IF NOT EXISTS todos (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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
