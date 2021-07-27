import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final User _authAccount;
  AppUser(this._authAccount);
  User get authAccount => _authAccount;
}