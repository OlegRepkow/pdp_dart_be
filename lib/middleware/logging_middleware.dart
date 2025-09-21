import 'dart:io';
import 'package:shelf/shelf.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class Logger {
  static LogLevel _currentLevel = LogLevel.info;

  static void setLevel(LogLevel level) {
    _currentLevel = level;
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  static void _log(
      LogLevel level, String message, Object? error, StackTrace? stackTrace) {
    if (level.index < _currentLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(7);

    if (error != null) {
      stderr.writeln('[$timestamp] $levelStr $message');
      stderr.writeln('Error: $error');
      if (stackTrace != null) {
        stderr.writeln('Stack trace: $stackTrace');
      }
    } else {
      stdout.writeln('[$timestamp] $levelStr $message');
    }
  }
}

class LoggingMiddleware {
  static Middleware requestLogger() {
    return (Handler innerHandler) {
      return (Request request) async {
        final startTime = DateTime.now();

        Logger.info('${request.method} ${request.url} - Started');

        try {
          final response = await innerHandler(request);
          final duration = DateTime.now().difference(startTime);

          Logger.info(
              '${request.method} ${request.url} - ${response.statusCode} - ${duration.inMilliseconds}ms');

          return response;
        } catch (error, stackTrace) {
          final duration = DateTime.now().difference(startTime);

          Logger.error(
            '${request.method} ${request.url} - Error - ${duration.inMilliseconds}ms',
            error,
            stackTrace,
          );

          rethrow;
        }
      };
    };
  }
}
