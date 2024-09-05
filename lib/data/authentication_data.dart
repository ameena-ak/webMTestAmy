import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/message_components.dart';
import 'firestor.dart';


abstract class AuthenticationDatasource {
  Future<void> register(String email, String password, String confirmPassword, BuildContext context);
  Future<void> login(String email, String password, BuildContext context);
}

class AuthenticationRemote extends AuthenticationDatasource {
  @override
  Future<void> login(String email, String password, BuildContext context) async {
    if (_validateEmail(email) && _validatePassword(password)) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      } catch (e) {

        showSnackBarError(context, 'Error logging in: $e');
      }
    } else {

      showSnackBarError(context, 'Invalid email or password');
    }
  }

  @override
  Future<void> register(
      String email,
      String password,
      String confirmPassword,
      BuildContext context,
      ) async {
    if (_validateEmail(email) &&
        _validatePassword(password) &&
        _validateConfirmPassword(password, confirmPassword)) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

      } catch (e) {

        showSnackBarError(context, 'Error registering user: $e');
      }
    } else {

      showSnackBarError(context, 'Invalid email, password, or confirm password',);
    }
  }

  bool _validateEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  bool _validateConfirmPassword(String password, String confirmPassword) {
    return password == confirmPassword;
  }


}
