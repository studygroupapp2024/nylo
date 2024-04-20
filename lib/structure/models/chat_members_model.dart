// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMembersModel {
  final String lastReadChat;
  final String userId;

  final bool isAdmin;
  final bool receiveNotification;

  ChatMembersModel({
    required this.lastReadChat,
    required this.userId,
    required this.isAdmin,
    required this.receiveNotification,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lastReadChat': lastReadChat,
      'userId': userId,
      'isAdmin': isAdmin,
      'receiveNotification': receiveNotification,
    };
  }

  factory ChatMembersModel.fromMap(Map<String, dynamic> map) {
    return ChatMembersModel(
      lastReadChat: map['lastReadChat'] as String,
      userId: map['userId'] as String,
      isAdmin: map['isAdmin'] as bool,
      receiveNotification: map['receiveNotification'] as bool,
    );
  }

  factory ChatMembersModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatMembersModel(
      lastReadChat: doc['lastReadChat'],
      userId: doc['userId'],
      isAdmin: doc['isAdmin'],
      receiveNotification: doc['receiveNotification'],
    );
  }
}
