// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class UserGroupModel {
  final String groupChatId;

  UserGroupModel({
    required this.groupChatId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseId': groupChatId,
    };
  }

  factory UserGroupModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> map) {
    return UserGroupModel(
      groupChatId: map['groupChatId'] as String,
    );
  }
}
