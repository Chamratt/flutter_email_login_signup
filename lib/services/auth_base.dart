import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBaseService {
  Future<String?> signIn(String email, String password);
  Future<String?> signUp(String email, String password);
  Future<void> sendMailVerification();
  Future<User?> getCurrentUser();
  Future<void> signOut();
}
