import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dansal_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://app03.kasunpremarathna.com/api';
  static const Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Register a new user
  Future<User?> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: headers,
        body: {'username': username, 'email': email, 'password': password},
      );

      print('Register API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final user = User(
            username: username,
            email: email,
            token:
                username, // Using username as token since no token is provided
          );

          // Save user data to secure storage
          await _saveUserData(user);

          // Also save to SharedPreferences for easier access
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('username', username);
          await prefs.setString('email', email);

          return user;
        } else {
          throw Exception(data['message'] ?? 'Registration failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Login user
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: headers,
        body: {'email': email, 'password': password},
      );

      print('Login API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Extract username from email or use email as username
          final username = email.split('@')[0];

          final user = User(
            username: username,
            email: email,
            token: email, // Using email as token since no token is provided
          );

          // Save user data to secure storage
          await _saveUserData(user);

          // Also save to SharedPreferences for easier access
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('username', username);
          await prefs.setString('email', email);

          return user;
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      // Since there's no token, we'll just clear local storage
      await _clearUserData();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      return true;
    } catch (e) {
      print('Logout error: $e');
      // Still clear user data on error
      await _clearUserData();
      return false;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      final email = prefs.getString('email');

      if (username != null && email != null) {
        return User(
          username: username,
          email: email,
          token: email, // Using email as token
        );
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Save user data to secure storage
  Future<void> _saveUserData(User user) async {
    await _storage.write(key: 'username', value: user.username);
    await _storage.write(key: 'email', value: user.email);
    if (user.token != null) {
      await _storage.write(key: 'token', value: user.token);
    }
  }

  // Clear user data from secure storage
  Future<void> _clearUserData() async {
    await _storage.deleteAll();
  }
}
