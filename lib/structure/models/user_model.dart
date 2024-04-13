// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String fcmtoken;
  final String imageUrl;
  final String university;
  final String universityId;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.fcmtoken,
    required this.imageUrl,
    required this.university,
    required this.universityId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'fcmtoken': fcmtoken,
      'imageUrl': imageUrl,
      'university': university,
      'universityId': universityId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      fcmtoken: map['fcmtoken'] as String,
      imageUrl: map['imageUrl'] as String,
      university: map['university'] as String,
      universityId: map['universityId'] as String,
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      fcmtoken: doc['fcmtoken'],
      imageUrl: doc['imageUrl'],
      university: doc['university'],
      universityId: doc['universityId'],
    );
  }
}
