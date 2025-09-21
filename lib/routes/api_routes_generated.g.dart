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
    'POST',
    r'/auth/register',
    service.register,
  );
  router.add(
    'POST',
    r'/auth/login',
    service.login,
  );
  router.add(
    'GET',
    r'/auth/profile',
    service.getProfile,
  );
  router.add(
    'PUT',
    r'/auth/profile',
    service.updateProfile,
  );
  router.add(
    'GET',
    r'/todos/all',
    service.getAllTodos,
  );
  router.add(
    'GET',
    r'/todos',
    service.getTodosByUserId,
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
