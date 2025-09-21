import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:crypto/crypto.dart';

class AuthMiddleware {
  static Middleware extractUser() {
    return (Handler inner) {
      return (Request request) async {
        final userId = request.headers['x-user-id'];

        if (userId != null) {
          request = request.change(context: {'userId': userId});
        }

        return inner(request);
      };
    };
  }

  static Middleware requireAuth() {
    return (Handler inner) {
      return (Request request) async {
        final userId = request.context['userId'] as String?;
        if (userId == null) {
          return Response(
            401,
            body: jsonEncode({
              'error': 'Unauthorized',
              'message': 'X-User-ID header required'
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }
        return inner(request);
      };
    };
  }

  // Простий генератор ID (хеш пароля)
  static String generateUserId(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
