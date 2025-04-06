import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dansal_app/models/user_model.dart';
import 'package:dansal_app/services/auth_service.dart';

// Provider for the AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provider for the current user
final userProvider = StateProvider<User?>((ref) => null);

// Provider that checks if the user is authenticated
final authProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isAuthenticated();
});

// Auth state notifier to manage login, logout and register
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;
  final Ref _ref;

  AuthNotifier(this._authService, this._ref)
    : super(const AsyncValue.loading()) {
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.getCurrentUser();
      state = AsyncValue.data(user);
      _ref.read(userProvider.notifier).state = user;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        state = AsyncValue.data(user);
        _ref.read(userProvider.notifier).state = user;
        return true;
      } else {
        state = const AsyncValue.data(null);
        return false;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print('Login error in provider: $e');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.register(username, email, password);
      if (user != null) {
        state = AsyncValue.data(user);
        _ref.read(userProvider.notifier).state = user;
        return true;
      } else {
        state = const AsyncValue.data(null);
        return false;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print('Registration error in provider: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    state = const AsyncValue.loading();
    try {
      final success = await _authService.logout();
      state = const AsyncValue.data(null);
      _ref.read(userProvider.notifier).state = null;
      return success;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
}

// Provider for the auth notifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
      final authService = ref.watch(authServiceProvider);
      return AuthNotifier(authService, ref);
    });
