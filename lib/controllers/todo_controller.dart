import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/todo_service.dart';

class TodoController {
  final TodoService _todoService = TodoService();

  Future<Response> createTodo(Request request) async {
    try {
      final userId = request.context['userId'] as String?;
      if (userId == null) {
        return Response(
          401,
          body: jsonEncode({'error': 'Unauthorized'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final title = data['title'] as String?;
      final description = data['description'] as String?;
      final isCompleted = data['is_completed'] as bool?;

      if (title == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Title is required'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final todo = await _todoService.createTodo(
          userId, title, description, isCompleted);
      return Response.ok(
        jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> getAllTodos(Request request) async {
    try {
      final todos = await _todoService.getAllTodos();
      return Response.ok(
        jsonEncode(todos.map((t) => t.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> getTodosByUserId(Request request) async {
    final userId = request.context['userId'] as String?;
    if (userId == null) {
      return Response(
        401,
        body: jsonEncode({'error': 'Unauthorized'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
    try {
      final todos = await _todoService.getTodosByUserId(userId);
      return Response.ok(
        jsonEncode(todos.map((t) => t.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> getTodoById(Request request, String id) async {
    try {
      final todo = await _todoService.getTodoById(id);
      if (todo == null) {
        return Response.notFound(
          jsonEncode({'error': 'Todo not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> updateTodo(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final title = data['title'] as String?;
      final description = data['description'] as String?;
      final isCompleted = data['is_completed'] as bool?;

      final todo =
          await _todoService.updateTodo(id, title, description, isCompleted);
      if (todo == null) {
        return Response.notFound(
          jsonEncode({'error': 'Todo not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> deleteTodo(Request request, String id) async {
    try {
      final deleted = await _todoService.deleteTodo(id);
      if (!deleted) {
        return Response.notFound(
          jsonEncode({'error': 'Todo not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'message': 'Todo deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> deleteAllTodos(Request request) async {
    try {
      await _todoService.deleteAllTodos();
      return Response.ok(
          jsonEncode({'message': 'All todos deleted successfully'}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  }
}
