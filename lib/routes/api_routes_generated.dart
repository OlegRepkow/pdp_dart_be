import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/todo_controller.dart';
import '../controllers/user_controller.dart';
import '../middleware/auth_middleware.dart';

part 'api_routes_generated.g.dart';

class ApiRoutes {
  final TodoController _todoController = TodoController();
  final UserController _userController = UserController();

  @Route.get('/health')
  Response health(Request request) {
    return Response.ok(
      '{"status": "ok","timestamp": "${DateTime.now().toIso8601String()}"}',
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Authentication routes
  @Route.post('/auth/register')
  Future<Response> register(Request request) =>
      _userController.register(request);

  @Route.post('/auth/login')
  Future<Response> login(Request request) => _userController.login(request);

  @Route.get('/auth/profile')
  Future<Response> getProfile(Request request) async => Pipeline()
      .addMiddleware(AuthMiddleware.requireAuth())
      .addHandler(_userController.getProfile)(request);

  @Route.put('/auth/profile')
  Future<Response> updateProfile(Request request) async => Pipeline()
      .addMiddleware(AuthMiddleware.requireAuth())
      .addHandler(_userController.updateProfile)(request);

  // Todos routes
  @Route.get('/todos/all')
  Future<Response> getAllTodos(Request request) =>
      _todoController.getAllTodos(request);

  @Route.get('/todos')
  Future<Response> getTodosByUserId(Request request) async => Pipeline()
      .addMiddleware(AuthMiddleware.requireAuth())
      .addHandler(_todoController.getTodosByUserId)(request);

  @Route.post('/todos/create')
  Future<Response> createTodo(Request request) async => Pipeline()
      .addMiddleware(AuthMiddleware.requireAuth())
      .addHandler(_todoController.createTodo)(request);

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
