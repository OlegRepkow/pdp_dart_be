import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/user_service.dart';
import '../middleware/auth_middleware.dart';

class UserController {
  final UserService _userService = UserService();

  Future<Response> register(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final username = data['username'] as String?;
      final email = data['email'] as String?;
      final password = data['password'] as String?;

      if (username == null || email == null || password == null) {
        return Response.badRequest(
          body: jsonEncode(
              {'error': 'Username, email, and password are required'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // Check if username already exists
      if (await _userService.getUserByUsername(username) != null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Username already exists'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // Check if email already exists
      if (await _userService.getUserByEmail(email) != null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Email already exists'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final user = await _userService.createUser(username, email, password);

      return Response.ok(
        jsonEncode({
          'message': 'User registered successfully',
          'user': {
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'created_at': user.createdAt.toIso8601String(),
          },
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> login(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final username = data['username'] as String?;
      final password = data['password'] as String?;

      if (username == null || password == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Username and password are required'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final user = await _userService.getUserByUsername(username);
      if (user == null ||
          !_userService.verifyPassword(password, user.passwordHash)) {
        return Response(
          401,
          body: jsonEncode({'error': 'Invalid credentials'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({
          'message': 'Login successful',
          'user': {
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'created_at': user.createdAt.toIso8601String(),
          },
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> getProfile(Request request) async {
    try {
      final userId = request.context['userId'] as String?;
      if (userId == null) {
        return Response(
          401,
          body: jsonEncode({'error': 'Unauthorized'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final user = await _userService.getUserById(userId);
      if (user == null) {
        return Response(
          404,
          body: jsonEncode({'error': 'User not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({
          'id': user.id,
          'username': user.username,
          'email': user.email,
          'created_at': user.createdAt.toIso8601String(),
          'updated_at': user.updatedAt.toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> updateProfile(Request request) async {
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

      final username = data['username'] as String?;
      final email = data['email'] as String?;
      final password = data['password'] as String?;

      final success = await _userService.updateUser(
        userId,
        username: username,
        email: email,
        password: password,
      );

      if (!success) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Failed to update profile'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({
          'message': 'Profile updated successfully',
          'new_user_id':
              password != null ? AuthMiddleware.generateUserId(password) : null,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
