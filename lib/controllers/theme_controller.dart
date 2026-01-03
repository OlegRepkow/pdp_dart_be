import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/theme_service.dart';

class ThemeController {
  final ThemeService _themeService = ThemeService();

  Future<Response> setTheme(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final mode = data['mode'] as String?;
      final themeData = data['data'] as Map<String, dynamic>?;

      if (mode == null || themeData == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'mode and data are required'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      if (mode != 'light' && mode != 'dark') {
        return Response.badRequest(
          body: jsonEncode({'error': 'mode must be "light" or "dark"'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final theme = await _themeService.setTheme(mode, themeData);
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
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> getTheme(Request request) async {
    try {
      final mode = request.url.queryParameters['mode'];
      if (mode == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'mode query parameter is required'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      if (mode != 'light' && mode != 'dark') {
        return Response.badRequest(
          body: jsonEncode({'error': 'mode must be "light" or "dark"'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final theme = await _themeService.getTheme(mode);
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
