import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static Future<void> updateUserInfo({required User user}) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      var snapshot = await transaction
          .get(FirebaseFirestore.instance.collection("users").doc(user.uid));
      transaction
          .set(FirebaseFirestore.instance.collection("users").doc(user.uid), {
        "first": user.displayName?.split(" ").first ?? "",
        "last": user.displayName?.split(" ").last ?? "",
        "name": user.displayName ?? "",
        "date": snapshot.data()?["date"] ?? DateTime.now(),
        "email": user.email ?? "",
        "uid": user.uid,
      });
    });
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getStories({required String categoryID}) {
    return FirebaseFirestore.instance.collection("stories").where("categories", arrayContains: categoryID).orderBy("date", descending: true).get();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getCategoryStream() {
    return FirebaseFirestore.instance.collection("config").doc("categories").snapshots();
  }
}
