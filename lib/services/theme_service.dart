import 'dart:convert';
import '../models/theme.dart';
import 'database_service.dart';

abstract class IThemeService {
  Future<Theme?> setTheme(Map<String, dynamic> data);
  Future<Theme?> getTheme();
}

class ThemeService implements IThemeService {
  final DatabaseService _db = DatabaseService.instance;

  @override
  Future<Theme?> setTheme(Map<String, dynamic> data) async {
    // Конвертуємо дані в JSONB
    final jsonData = jsonEncode(data);

    // Видаляємо всі існуючі записи та вставляємо новий
    // Це забезпечує, що завжди буде тільки один запис
    await _db.connection.execute('DELETE FROM themes');

    final result = await _db.connection.execute(
      'INSERT INTO themes (theme_data) VALUES (\$1::jsonb) RETURNING *',
      parameters: [jsonData],
    );

    if (result.isEmpty) return null;

    final row = result.first.toColumnMap();
    // Витягуємо theme_data з JSONB і парсимо
    final themeDataJson = row['theme_data'];
    final themeData = themeDataJson is String
        ? jsonDecode(themeDataJson) as Map<String, dynamic>
        : themeDataJson as Map<String, dynamic>;

    return Theme.fromJson(themeData);
  }

  @override
  Future<Theme?> getTheme() async {
    final result = await _db.connection.execute(
      'SELECT * FROM themes LIMIT 1',
    );
    if (result.isEmpty) return null;

    final row = result.first.toColumnMap();
    // Витягуємо theme_data з JSONB і парсимо
    final themeDataJson = row['theme_data'];
    final themeData = themeDataJson is String
        ? jsonDecode(themeDataJson) as Map<String, dynamic>
        : themeDataJson as Map<String, dynamic>;

    return Theme.fromJson(themeData);
  }
}
