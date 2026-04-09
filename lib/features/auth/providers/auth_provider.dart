import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/user_role.dart';

class MockUser implements User {
  final String _uid;
  final String? _email;
  final String? _displayName;
  final String? _phoneNumber;

  MockUser({required String uid, String? email, String? displayName, String? phoneNumber}) 
    : _uid = uid, _email = email, _displayName = displayName, _phoneNumber = phoneNumber;

  @override
  String get uid => _uid;
  @override
  String? get email => _email;
  @override
  String? get displayName => _displayName;
  @override
  String? get phoneNumber => _phoneNumber;

  @override
  bool get emailVerified => true;
  @override
  bool get isAnonymous => false;
  @override
  UserMetadata get metadata => throw UnimplementedError();
  @override
  List<UserInfo> get providerData => [];
  @override
  String? get refreshToken => null;
  @override
  String? get tenantId => null;
  @override
  Future<void> delete() async {}
  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock_token';
  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) => throw UnimplementedError();
  @override
  Future<void> reload() async {}
  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}
  @override
  Future<void> updateDisplayName(String? displayName) async {}
  @override
  Future<void> updateEmail(String email) async {}
  @override
  Future<void> updatePassword(String password) async {}
  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential credential) async {}
  @override
  Future<void> updatePhotoURL(String? photoURL) async {}
  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) async {}
  @override
  String? get photoURL => null;
  @override
  Future<User> unlink(String providerId) async => this;
  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) => throw UnimplementedError();
  @override
  Future<UserCredential> linkWithPopup(dynamic provider) => throw UnimplementedError();
  @override
  Future<UserCredential> linkWithProvider(dynamic provider) => throw UnimplementedError();
  @override
  Future<UserCredential> linkWithRedirect(dynamic provider) => throw UnimplementedError();
  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) => throw UnimplementedError();
  @override
  Future<UserCredential> reauthenticateWithPopup(dynamic provider) => throw UnimplementedError();
  @override
  Future<UserCredential> reauthenticateWithProvider(dynamic provider) => throw UnimplementedError();
  @override
  Future<UserCredential> reauthenticateWithRedirect(dynamic provider) => throw UnimplementedError();
  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber, [RecaptchaVerifier? verifier]) => throw UnimplementedError();
  @override
  Future<ConfirmationResult> reauthenticateWithPhoneNumber(String phoneNumber, [RecaptchaVerifier? verifier]) => throw UnimplementedError();
  @override
  MultiFactor get multiFactor => throw UnimplementedError();
  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}
}

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

  Future<void> sendMockOtp(String identifier, bool isAdmin) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    _setLoading(false);
  }

  Future<void> verifyMockOtp(String identifier, String smsCode, bool isAdmin) async {
    if (smsCode != "123456") throw Exception("Invalid OTP");
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    _user = MockUser(
      uid: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      email: identifier.contains('@') ? identifier : null,
      phoneNumber: identifier.contains('@') ? null : identifier,
    );
    _role = isAdmin ? UserRole.admin : UserRole.member;
    _setLoading(false);
    notifyListeners();
  }

  Future<void> updateDisplayName(String name) async {
    if (_user == null) return;
    
    _setLoading(true);
    try {
      if (_user is MockUser) {
        _user = MockUser(
          uid: _user!.uid,
          email: _user!.email,
          phoneNumber: _user!.phoneNumber,
          displayName: name,
        );
      } else {
        await _user!.updateDisplayName(name);
        await _user!.reload();
        _user = FirebaseAuth.instance.currentUser;
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to update display name: $e');
    } finally {
      _setLoading(false);
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
