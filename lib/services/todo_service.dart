import '../models/todo.dart';
import 'database_service.dart';

class TodoService {
  final DatabaseService _db = DatabaseService.instance;

  Future<Todo> createTodo(String userId, String title, String? description,
      bool? isCompleted) async {
    final result = await _db.connection.execute(
      'INSERT INTO todos (user_id, title, description, is_completed) VALUES (\$1, \$2, \$3, \$4) RETURNING *',
      parameters: [userId, title, description, isCompleted ?? false],
    );

    return Todo.fromJson(result.first.toColumnMap());
  }

  Future<Todo?> getTodoById(String id) async {
    final result = await _db.connection.execute(
      'SELECT * FROM todos WHERE id = \$1',
      parameters: [id],
    );

    if (result.isEmpty) return null;
    return Todo.fromJson(result.first.toColumnMap());
  }

  Future<List<Todo>> getAllTodos() async {
    final result = await _db.connection
        .execute('SELECT * FROM todos ORDER BY created_at DESC');

    return result.map((row) => Todo.fromJson(row.toColumnMap())).toList();
  }

  Future<List<Todo>> getTodosByUserId(String userId) async {
    final result = await _db.connection.execute(
      'SELECT * FROM todos WHERE user_id = \$1 ORDER BY created_at DESC',
      parameters: [userId],
    );

    return result.map((row) => Todo.fromJson(row.toColumnMap())).toList();
  }

  Future<Todo?> updateTodo(
      String id, String? title, String? description, bool? isCompleted) async {
    final updates = <String>[];
    final values = <dynamic>[id];
    int paramIndex = 2;

    if (title != null) {
      updates.add('title = \$$paramIndex');
      values.add(title);
      paramIndex++;
    }
    if (description != null) {
      updates.add('description = \$$paramIndex');
      values.add(description);
      paramIndex++;
    }
    if (isCompleted != null) {
      updates.add('is_completed = \$$paramIndex');
      values.add(isCompleted);
      paramIndex++;
    }

    if (updates.isEmpty) return null;

    updates.add('updated_at = CURRENT_TIMESTAMP');

    final result = await _db.connection.execute(
      'UPDATE todos SET ${updates.join(', ')} WHERE id = \$1 RETURNING *',
      parameters: values,
    );

    if (result.isEmpty) return null;
    return Todo.fromJson(result.first.toColumnMap());
  }

  Future<bool> deleteTodo(String id) async {
    final result = await _db.connection.execute(
      'DELETE FROM todos WHERE id = \$1',
      parameters: [id],
    );

    return result.affectedRows > 0;
  }

  Future<bool> deleteAllTodos() async {
    final result = await _db.connection.execute(
      'DELETE FROM todos',
    );
    return result.affectedRows == 0;
  }
}
