import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String name;
  final String email;
  final String phone;
  final String password;

  const AppUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
      );
}

class UserProvider extends ChangeNotifier {
  AppUser? _currentUser;
  List<AppUser> _registeredUsers = [];
  bool _isLoading = true;

  static const String _usersKey = 'registered_users';
  static const String _loggedInKey = 'logged_in_email';

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadFromPrefs();
  }

  // ── Load persisted data on startup ──────────────────────────────
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load all registered users
      final usersJson = prefs.getString(_usersKey);
      if (usersJson != null) {
        final List<dynamic> decoded = jsonDecode(usersJson);
        _registeredUsers =
            decoded.map((u) => AppUser.fromJson(u)).toList();
      }

      // Restore logged-in session
      final loggedInEmail = prefs.getString(_loggedInKey);
      if (loggedInEmail != null) {
        try {
          _currentUser = _registeredUsers.firstWhere(
            (u) => u.email == loggedInEmail,
          );
        } catch (_) {
          // User not found — clear stale session
          await prefs.remove(_loggedInKey);
        }
      }
    } catch (e) {
      debugPrint('Error loading prefs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Save all users to prefs ──────────────────────────────────────
  Future<void> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded =
          jsonEncode(_registeredUsers.map((u) => u.toJson()).toList());
      await prefs.setString(_usersKey, encoded);
    } catch (e) {
      debugPrint('Error saving users: $e');
    }
  }

  // ── Save logged-in session ───────────────────────────────────────
  Future<void> _saveSession(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_loggedInKey, email);
    } catch (e) {
      debugPrint('Error saving session: $e');
    }
  }

  // ── Clear session ────────────────────────────────────────────────
  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_loggedInKey);
    } catch (e) {
      debugPrint('Error clearing session: $e');
    }
  }

  // ── Register ─────────────────────────────────────────────────────
  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final exists = _registeredUsers.any(
      (u) => u.email.toLowerCase() == email.toLowerCase().trim(),
    );
    if (exists) return 'An account with this email already exists.';

    final user = AppUser(
      name: name,
      email: email.toLowerCase().trim(),
      phone: phone.trim(),
      password: password,
    );
    _registeredUsers.add(user);
    await _saveUsers();
    notifyListeners();
    return null; // null = success
  }

  // ── Login ─────────────────────────────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final emailLower = email.toLowerCase().trim();

    AppUser? found;
    try {
      found = _registeredUsers.firstWhere(
        (u) => u.email == emailLower,
      );
    } catch (_) {
      found = null;
    }

    if (found == null) {
      return 'No account found with this email.\nPlease register first.';
    }

    if (found.password != password) {
      return 'Incorrect password. Please try again.';
    }

    _currentUser = found;
    await _saveSession(found.email);
    notifyListeners();
    return null; // null = success
  }

  // ── Logout ────────────────────────────────────────────────────────
  Future<void> logout() async {
    _currentUser = null;
    await _clearSession();
    notifyListeners();
  }
}