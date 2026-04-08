import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/user_role.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  UserRole _role = UserRole.guest;
  String? _verificationId;
  bool _isLoading = false;

  AuthProvider() {
    _authService.user.listen(_onAuthStateChanged);
  }

  User? get user => _user;
  UserRole get role => _role;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _role == UserRole.admin;

  void _onAuthStateChanged(User? user) {
    _user = user;
    if (user == null) {
      _role = UserRole.guest;
    }
    notifyListeners();
  }

  Future<void> sendOtp(String phoneNumber, bool isAdmin, {required Function(String) onCodeSent, required Function(String) onError}) async {
    _setLoading(true);
    await _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        _verificationId = verificationId;
        _setLoading(false);
        onCodeSent(verificationId);
      },
      onError: (e) {
        _setLoading(false);
        onError(e.message ?? "Authentication failed");
      },
      onAutoVerify: (credential) {
        _setLoading(false);
      },
    );
  }

  Future<void> verifyOtp(String smsCode, bool isAdmin) async {
    if (_verificationId == null) return;
    _setLoading(true);
    try {
      await _authService.signInWithOtp(_verificationId!, smsCode);
      _role = isAdmin ? UserRole.admin : UserRole.member;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // Disabling hardcoded demo login methods for Firebase testing
  // void loginAsAdmin() {
  //   _role = UserRole.admin;
  //   notifyListeners();
  // }

  // void loginAsMember() {
  //   _role = UserRole.member;
  //   notifyListeners();
  // }

  Future<void> logout() async {
    await _authService.signOut();
    _role = UserRole.guest;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
