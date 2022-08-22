import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String age;

  UserModel({required this.userName, required this.age});

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      userName: snapshot['username'],
      age: snapshot['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": userName,
      "age": age,
    };
  }
}
