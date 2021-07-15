import 'dart:async';

import 'package:app/models/app_user.dart';
import 'package:app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
  static const List<String> whitelisted = ["danielnmwu@gmail.com"];
  static late final FirebaseAuth _auth;

  static Future<void> initialize() async {
    _controller.onCancel = () {
      _controller.close();
    };
    _auth = FirebaseAuth.instance;
    /*
    await _googleSignIn.signInSilently();
    if (!_auth.currentUser.isNull && !_googleSignIn.currentUser.isNull) {
      _controller.add(AppUser(_googleSignIn.currentUser!, _auth.currentUser!));
      return;
    }*/
    if (!_googleSignIn.currentUser.isNull) _googleSignIn.signOut();
    if (!_auth.currentUser.isNull) _auth.signOut();
    _controller.add(null);
  }

  static Future<void> signIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      if (!whitelisted.contains(googleSignInAccount?.email) &&
          !domains.contains(googleSignInAccount?.email.split("@").last)) {
        throw PlatformException(
            code:
                "invalid-email:${googleSignInAccount?.email ?? "Google account"}");
      }
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      await FirestoreService.updateUserInfo(user: authResult.user!);
      _controller.add(AppUser(_googleSignIn.currentUser!, authResult.user!));
    } on PlatformException catch (e) {
      switch (e.code) {
        case "popup_closed_by_user":
          throw "";
        case "ERROR_TOO_MANY_REQUESTS":
          throw "Too many requests to log into this account.";
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          throw "Server error, please try again later.";
        case "invalid-email":
          throw "Not a valid email.";
        default:
          var paramException = e.code.split(":");
          switch (paramException.first) {
            case "invalid-email":
              throw "${paramException.last} is not a valid Naperville 203 Google Account";
            default:
              throw "Login failed. Please try again. (code: ${e.code})";
          }
      }
    }
  }

  static Future<void> signOut() async {
    if (!_googleSignIn.currentUser.isNull) _googleSignIn.signOut();
    if (!_auth.currentUser.isNull) _auth.signOut();
    _controller.add(null);
  }
}
