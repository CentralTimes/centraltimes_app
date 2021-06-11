import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  final GoogleSignInAccount _googleSignInAccount;
  final User _authAccount;

  AppUser(this._googleSignInAccount, this._authAccount);
  GoogleSignInAccount get googleSignInAccount => _googleSignInAccount;
  User get authAccount => _authAccount;
}