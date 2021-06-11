import 'dart:async';

import 'package:app/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app/constants.dart';

class AuthService {
  static final StreamController<AppUser?> _controller =
      StreamController<AppUser?>();
  static Stream<AppUser?> get onUserChanged => _controller.stream;
  static final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: ["email", "profile"]);
  static const List<String> domains = [
    "stu.naperville203.org",
    "naperville203.org"
  ];
  static late final FirebaseAuth _auth;

  static Future<void> initialize() async {
    _controller.onCancel = () {
      _controller.close();
    };
    _auth = FirebaseAuth.instance;
    await _googleSignIn.signInSilently();
    if (!_auth.currentUser.isNull && !_googleSignIn.currentUser.isNull) {
      _controller.add(AppUser(_googleSignIn.currentUser!, _auth.currentUser!));
      return;
    }
    if (!_googleSignIn.currentUser.isNull) _googleSignIn.signOut();
    if (!_auth.currentUser.isNull) _auth.signOut();
    _controller.add(null);
  }

  static Future<void> signIn() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    if (googleSignInAuthentication.isNull) return;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    _controller.add(AppUser(_googleSignIn.currentUser!, authResult.user!));
  }

  static Future<void> signOut() async {
    if (!_googleSignIn.currentUser.isNull) _googleSignIn.signOut();
    if (!_auth.currentUser.isNull) _auth.signOut();
    _controller.add(null);
  }

  static String getMessageFromSignInErrorCode(e) {
    switch (e.code) {
      case "popup_closed_by_user":
        return "Google Sign In OAuth consent screen closed by the user";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Google account is not a valid Naperville 203 account";
      default:
        return "Login failed. Please try again.";
    }
  }

  static String getMessageFromSignOutErrorCode(e) {
    switch (e) {
      default:
        return "Error occurred while signing out.";
    }
  }
}
