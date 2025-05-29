// lib/auth_state_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/services/api_service.dart';

class AuthStateService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _jwtToken;
  String? _userId;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get jwtToken => _jwtToken;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  AuthStateService() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _jwtToken = prefs.getString('jwt_token');
    _userId = prefs.getString('user_id');
    _userName = prefs.getString('user_name');
    _userEmail = prefs.getString('user_email');
    _isLoggedIn = _jwtToken != null;
    notifyListeners();
  }

  Future<void> setLoggedIn({
    required String token,
    required String id,
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('user_id', id);
    await prefs.setString('user_name', username);
    await prefs.setString('user_email', email);

    _jwtToken = token;
    _userId = id;
    _userName = username;
    _userEmail = email;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> setLoggedOut() async {
    final apiService = ApiService();
    await apiService.logout();

    _jwtToken = null;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
