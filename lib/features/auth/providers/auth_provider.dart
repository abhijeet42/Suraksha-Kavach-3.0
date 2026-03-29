import 'package:flutter/material.dart';
import '../../../data/models/user_role.dart';

class AuthProvider extends ChangeNotifier {
  UserRole _role = UserRole.guest;

  UserRole get role => _role;

  bool get isAuthenticated => _role != UserRole.guest;
  bool get isAdmin => _role == UserRole.admin;

  void loginAsAdmin() {
    _role = UserRole.admin;
    notifyListeners();
  }

  void loginAsMember() {
    _role = UserRole.member;
    notifyListeners();
  }

  void logout() {
    _role = UserRole.guest;
    notifyListeners();
  }
}
