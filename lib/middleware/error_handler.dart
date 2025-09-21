import 'dart:convert';
import 'package:shelf/shelf.dart';

class ErrorHandler {
  static Response handleError(dynamic error, StackTrace? stackTrace) {
    print('Error: $error');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }

    // Определяем тип ошибки и возвращаем соответствующий ответ
    if (error is FormatException) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid JSON format',
          'message': error.message,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    if (error is ArgumentError) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid argument',
          'message': error.message,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    // Общая ошибка сервера
    return Response.internalServerError(
      body: jsonEncode({
        'error': 'Internal server error',
        'message': 'An unexpected error occurred',
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Response notFound(String message) {
    return Response.notFound(
      jsonEncode({
        'error': 'Not found',
        'message': message,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Response badRequest(String message) {
    return Response.badRequest(
      body: jsonEncode({
        'error': 'Bad request',
        'message': message,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Response unauthorized(String message) {
    return Response(
      401,
      body: jsonEncode({
        'error': 'Unauthorized',
        'message': message,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Response forbidden(String message) {
    return Response(
      403,
      body: jsonEncode({
        'error': 'Forbidden',
        'message': message,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
