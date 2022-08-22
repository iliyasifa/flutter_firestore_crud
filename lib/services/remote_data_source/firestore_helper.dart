import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class FirestoreHelper {
  static Future<List<UserModel>> read() async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final data = await userCollection.get();
    final docList = data.docs;
    debugPrint('$docList');

    return docList.map((e) => UserModel.fromSnapshot(e)).toList();
  }

  static Future create(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc();

    try {
      await docRef.set(user.toJson());
    } catch (e) {
      debugPrint('Some error occurred $e');
    }
  }
}
