import 'dart:convert';
import '../models/theme.dart';
import 'database_service.dart';

abstract class IThemeService {
  Future<Theme?> setTheme(String themeValue, Map<String, dynamic> data);
  Future<Theme?> getTheme(String themeValue);
}

class ThemeService implements IThemeService {
  final DatabaseService _db = DatabaseService.instance;

  @override
  Future<Theme?> setTheme(String themeValue, Map<String, dynamic> data) async {
    // Перевіряємо чи вже існує тема
    final existing = await getTheme(themeValue);

    final result = existing == null
        ? await _db.connection.execute(
            'INSERT INTO themes (mode, data) VALUES (\$1, \$2::jsonb) RETURNING *',
            parameters: [themeValue, jsonEncode(data)],
          )
        : await _db.connection.execute(
            'UPDATE themes SET data = \$1::jsonb WHERE mode = \$2 RETURNING *',
            parameters: [jsonEncode(data), themeValue],
          );

    final row = result.first.toColumnMap();
    // Парсимо JSONB data
    if (row['data'] is String) {
      row['data'] = jsonDecode(row['data'] as String);
    }

    return Theme.fromJson(row);
  }

  @override
  Future<Theme?> getTheme(String themeValue) async {
    final result = await _db.connection.execute(
      'SELECT * FROM themes WHERE mode = \$1',
      parameters: [themeValue],
    );

    if (result.isEmpty) return null;

    final row = result.first.toColumnMap();
    // Парсимо JSONB data
    if (row['data'] is String) {
      row['data'] = jsonDecode(row['data'] as String);
    }

    return Theme.fromJson(row);
  }
}
