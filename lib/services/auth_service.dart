import 'package:booking/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthService extends AuthBaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late BuildContext context;
  @override
  Future<String?> signIn(String email, String password) async {
    String error = "";
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user?.email;
    } on PlatformException catch (e) {
      error = e.message!;
      return error;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          error = "email address is invalid!";
          break;
        case "user-disabled":
          error = "this user has been disabled!";
          break;
        case "user-not-found":
          error = "email not found";
          break;
        case "wrong-password":
          error = "wrong password";
          break;
        default:
          error = "other error $e";
      }
      return error;
    }
  }

  @override
  Future<String?> signUp(String email, String password) async {
    String error = "";
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user?.email;
    } on PlatformException catch (e) {
      error = e.message!;
      return error;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          error = "email is already in use!";
          break;
        case "invalid-email":
          error = "email is invalid!";
          break;
        case "operation-not-allowed":
          error = "operation fail!";
          break;
        case "weak-password":
          error = "password is weak!";
          break;
        default:
          error = "other error $e";
      }
      return error;
    }
  }

  Future<void> sendMailVerification() async {
    User? user = _auth.currentUser;
    user!.sendEmailVerification();
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
