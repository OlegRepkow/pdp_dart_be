// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_routes_generated.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ApiRoutesRouter(ApiRoutes service) {
  final router = Router();
  router.add(
    'GET',
    r'/health',
    service.health,
  );
  router.add(
    'GET',
    r'/todos/all',
    service.getAllTodos,
  );
  router.add(
    'POST',
    r'/todos/create',
    service.createTodo,
  );
  router.add(
    'GET',
    r'/todos/get/<id>',
    service.getTodoById,
  );
  router.add(
    'PUT',
    r'/todos/update/<id>',
    service.updateTodo,
  );
  router.add(
    'DELETE',
    r'/todos/delete/<id>',
    service.deleteTodo,
  );
  router.add(
    'DELETE',
    r'/todos/all',
    service.deleteAllTodos,
  );
  return router;
}
