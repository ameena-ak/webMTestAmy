import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _user = _firebaseAuth.currentUser;
    _isAuthenticated = _user != null;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      _isAuthenticated = _user != null;
      notifyListeners();
    } catch (e) {

      print(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      _isAuthenticated = _user != null;
      notifyListeners();
    } catch (e) {

      print(e);
    }
  }
}
