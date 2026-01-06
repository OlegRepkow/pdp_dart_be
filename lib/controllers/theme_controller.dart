import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/theme_service.dart';

class ThemeController {
  final ThemeService _themeService = ThemeService();

  Future<Response> setTheme(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = jsonDecode(body) as Map<String, dynamic>;

      // Витягуємо themeData з JSON, якщо він є, інакше використовуємо весь об'єкт
      Map<String, dynamic> themeData;
      if (jsonData.containsKey('themeData')) {
        themeData = jsonData['themeData'] as Map<String, dynamic>;
      } else {
        themeData = jsonData;
      }

      final theme = await _themeService.setTheme(themeData);
      if (theme == null) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Failed to save theme'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode(theme.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, stackTrace) {
      print('Error in setTheme: $e');
      print('Stack trace: $stackTrace');
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> getTheme(Request request) async {
    try {
      final theme = await _themeService.getTheme();

      if (theme == null) {
        return Response.notFound(
          jsonEncode({'error': 'Theme not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode(theme.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
