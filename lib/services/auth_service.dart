import 'dart:async';

import 'package:app/models/app_user.dart';
import 'package:app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  static const testUid = "9DSH0hASxCWoYHpzdszVuSgMK3F2";
  static late final FirebaseAuth _auth;

  static void initialize() {
    _controller.onCancel = () {
      _controller.close();
    };
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        _controller.add(null);
      } else {
        if (user.uid == testUid) {
          await FirestoreService.updateUserInfo(user: AppUser(user.email!, user.uid, "Test Account"));
          _controller.add(AppUser(user.email!, user.uid, "Test Account"));
        } else {
          await FirestoreService.updateUserInfo(user: AppUser(user.email!, user.uid, user.displayName!));
          _controller.add(AppUser(user.email!, user.uid, user.displayName!));
        }
      }
    });
  }

  static Future<void> signIn({bool test = false, String? email, String? password}) async {
    try {
      if (test) {
        final UserCredential result = await _auth.signInWithEmailAndPassword(email: email!, password: password!);
        await FirestoreService.updateUserInfo(user: AppUser(result.user!.email!, result.user!.uid,  "Test Account"));
        _controller.add(AppUser(result.user!.email!, result.user!.uid, "Test Account"));
      } else {
        final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
        final GoogleSignInAuthentication? googleSignInAuthentication =
            await googleSignInAccount?.authentication;
        if (googleSignInAccount == null) throw PlatformException(code: "popup_closed_by_user");
        if (!domains.contains(googleSignInAccount.email.split("@").last)) {
          signOut();
          throw PlatformException(
              code:
                  "invalid-email:${googleSignInAccount.email}");
        }
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication?.accessToken,
          idToken: googleSignInAuthentication?.idToken,
        );
        final UserCredential result = await _auth.signInWithCredential(credential);
        await FirestoreService.updateUserInfo(user: AppUser(result.user!.email!, result.user!.uid, result.user!.displayName!));
        _controller.add(AppUser(result.user!.email!, result.user!.uid, result.user!.displayName!));
        //_controller.add(AppUser(authResult.user!));
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "popup_closed_by_user":
          throw "";
        case "ERROR_TOO_MANY_REQUESTS":
          throw "Too many requests to log into this account.";
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          throw "Server error, please try again later.";
        case "user-disabled":
         throw "Account not available.";
        case "invalid-email":
          throw "Not a valid email and/or password.";
        case "wrong-password":
          throw "Not a valid email and/or password.";
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
    if (_googleSignIn.currentUser != null) _googleSignIn.signOut();
    if (_auth.currentUser != null) _auth.signOut();
  }
}
