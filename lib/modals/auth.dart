import 'package:betflow_mobile_app/services/auth.service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;

  Future<void> register(String username, String password) async {
    await _authService.register(username, password);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    await _authService.login(username, password);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    try {
      final profileResponse = await _authService.getProfile();
      final userId = profileResponse.data['_id'];
      final userResponse = await _authService.getUserById(userId);
      _user = userResponse.data;
      notifyListeners();
    } catch (e) {
      print('Error fetching user profile: $e');
      throw e;
    }
  }
}
