import '../models/user.dart';
import 'database_service.dart';
import '../middleware/auth_middleware.dart';

abstract class IUserService {
  Future<User> createUser(String username, String email, String password);
  Future<User?> getUserByUsername(String username);
  Future<User?> getUserById(String id);
  Future<User?> getUserByEmail(String email);
  bool verifyPassword(String password, String storedPassword);
  Future<List<User>> getAllUsers();
  Future<bool> updateUser(String id,
      {String? username, String? email, String? password});
  Future<bool> deleteUser(String id);
}

class UserService implements IUserService {
  final DatabaseService _db = DatabaseService.instance;

  @override
  Future<User> createUser(
      String username, String email, String password) async {
    final userId = AuthMiddleware.generateUserId(password);
    final result = await _db.connection.execute(
      'INSERT INTO users (id, username, email, password_hash) VALUES (\$1, \$2, \$3, \$4) RETURNING *',
      parameters: [userId, username, email, password],
    );
    return User.fromJson(result.first.toColumnMap());
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    final result = await _db.connection.execute(
      'SELECT * FROM users WHERE username = \$1',
      parameters: [username],
    );
    if (result.isEmpty) return null;
    return User.fromJson(result.first.toColumnMap());
  }

  @override
  Future<User?> getUserById(String id) async {
    final result = await _db.connection.execute(
      'SELECT * FROM users WHERE id = \$1',
      parameters: [id],
    );
    if (result.isEmpty) return null;
    return User.fromJson(result.first.toColumnMap());
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final result = await _db.connection.execute(
      'SELECT * FROM users WHERE email = \$1',
      parameters: [email],
    );
    if (result.isEmpty) return null;
    return User.fromJson(result.first.toColumnMap());
  }

  @override
  bool verifyPassword(String password, String storedPassword) {
    return password == storedPassword;
  }

  @override
  Future<List<User>> getAllUsers() async {
    final result = await _db.connection.execute(
      'SELECT * FROM users ORDER BY created_at DESC',
    );
    return result.map((row) => User.fromJson(row.toColumnMap())).toList();
  }

  @override
  Future<bool> updateUser(String id,
      {String? username, String? email, String? password}) async {
    if (password != null) {
      // Якщо змінюємо пароль, потрібно оновити і id (хеш пароля)
      // Це потребує транзакції, оскільки потрібно оновити і todos
      final newId = AuthMiddleware.generateUserId(password);

      try {
        await _db.connection.execute('BEGIN');

        // Тимчасово відключаємо foreign key constraint
        await _db.connection.execute('SET session_replication_role = replica');

        // Оновлюємо користувача
        final result = await _db.connection.execute(
          'UPDATE users SET id = \$1, password_hash = \$2, updated_at = CURRENT_TIMESTAMP WHERE id = \$3',
          parameters: [newId, password, id],
        );

        // Оновлюємо todos з новим user_id
        await _db.connection.execute(
          'UPDATE todos SET user_id = \$1 WHERE user_id = \$2',
          parameters: [newId, id],
        );

        // Включаємо foreign key constraint назад
        await _db.connection.execute('SET session_replication_role = DEFAULT');

        await _db.connection.execute('COMMIT');
        return result.affectedRows > 0;
      } catch (e) {
        await _db.connection.execute('ROLLBACK');
        rethrow;
      }
    } else {
      // Якщо не змінюємо пароль, просто оновлюємо інші поля
      final updates = <String>[];
      final values = <dynamic>[];
      int paramIndex = 1;

      if (username != null) {
        updates.add('username = \$$paramIndex');
        values.add(username);
        paramIndex++;
      }

      if (email != null) {
        updates.add('email = \$$paramIndex');
        values.add(email);
        paramIndex++;
      }

      if (updates.isEmpty) return false;

      updates.add('updated_at = CURRENT_TIMESTAMP');
      values.add(id); // ID для WHERE умови

      final query =
          'UPDATE users SET ${updates.join(', ')} WHERE id = \$$paramIndex';
      final result = await _db.connection.execute(query, parameters: values);

      return result.affectedRows > 0;
    }
  }

  @override
  Future<bool> deleteUser(String id) async {
    final result = await _db.connection.execute(
      'DELETE FROM users WHERE id = \$1',
      parameters: [id],
    );
    return result.isNotEmpty;
  }
}
