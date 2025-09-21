import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/todo_controller.dart';

part 'api_routes_generated.g.dart';

class ApiRoutes {
  final TodoController _todoController = TodoController();

  @Route.get('/health')
  Response health(Request request) {
    return Response.ok(
      '{"status": "ok","timestamp": "${DateTime.now().toIso8601String()}"}',
      headers: {'Content-Type': 'application/json'},
    );
  }

  @Route.get('/todos/all')
  Future<Response> getAllTodos(Request request) =>
      _todoController.getAllTodos(request);

  @Route.post('/todos/create')
  Future<Response> createTodo(Request request) =>
      _todoController.createTodo(request);

  @Route.get('/todos/get/<id>')
  Future<Response> getTodoById(Request request, String id) =>
      _todoController.getTodoById(request, id);

  @Route.put('/todos/update/<id>')
  Future<Response> updateTodo(Request request, String id) =>
      _todoController.updateTodo(request, id);

  @Route.delete('/todos/delete/<id>')
  Future<Response> deleteTodo(Request request, String id) =>
      _todoController.deleteTodo(request, id);

  @Route.delete('/todos/all')
  Future<Response> deleteAllTodos(Request request) =>
      _todoController.deleteAllTodos(request);

  Router get router => _$ApiRoutesRouter(this);
}
