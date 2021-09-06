import 'dart:async';

import 'package:app/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  static Future<void> updateUserInfo({required AppUser user}) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      var snapshot = await transaction
          .get(FirebaseFirestore.instance.collection("users").doc(user.uid));
      transaction
          .set(FirebaseFirestore.instance.collection("users").doc(user.uid), {
        "first": user.first,
        "last": user.last,
        "name": user.name,
        "date": snapshot.data()?["date"] ?? DateTime.now(),
        "email": user.email,
        "uid": user.uid,
      });
    });
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getStories(
      {required String categoryID}) {
    try {
      return FirebaseFirestore.instance
          .collection("stories")
          .where("categories", arrayContains: categoryID)
          .where("published", isEqualTo: true)
          .orderBy("publishdate", descending: true)
          .get();
    } on PlatformException catch (e) {
      throw e.code;
    }
  }

  //static Future<QuerySnapshot<Map<String, dynamic>>> searchStories({required String search}) {}

  static Future<DocumentSnapshot<Map<String, dynamic>>> getCategories() {
    return FirebaseFirestore.instance
        .collection("config")
        .doc("categories")
        .get();
  }

  static Future<List<DocumentSnapshot<Map<String, dynamic>>>> getSavedStories(
      {required List<String> storyIDs}) {
    return Future.wait(storyIDs.map((id) =>
        FirebaseFirestore.instance.collection("stories").doc(id).get()));
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getCategoryStream() {
    return FirebaseFirestore.instance
        .collection("config")
        .doc("categories")
        .snapshots();
  }
}
