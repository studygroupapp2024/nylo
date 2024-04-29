// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class DirectMessageModel {
  final String? chatId;
  final Timestamp timestamp;
  final String lastMessage;
  final String lastMessageSender;
  final Timestamp? lastMessageTimeSent;
  final String lastMessageType;
  final List<dynamic> membersId;
  final String proctorId;
  final String classId;
  final String tuteeId;
  final String? lastMessageId;

  DirectMessageModel({
    this.chatId,
    required this.timestamp,
    required this.lastMessage,
    required this.lastMessageSender,
    required this.lastMessageTimeSent,
    required this.lastMessageType,
    required this.membersId,
    required this.proctorId,
    required this.classId,
    required this.tuteeId,
    required this.lastMessageId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'createdAt': timestamp,
      'lastMessage': lastMessage,
      'lastMessageSender': lastMessageSender,
      'lastMessageTimeSent': lastMessageTimeSent,
      'lastMessageType': lastMessageType,
      'membersId': membersId,
      'proctorId': proctorId,
      'classId': classId,
      'tuteeId': tuteeId,
      'lastMessageId': lastMessageId
    };
  }

  factory DirectMessageModel.fromMap(Map<String, dynamic> map) {
    return DirectMessageModel(
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      timestamp: Timestamp.fromDate(DateTime.parse(map['createdAt'] as String)),
      lastMessage: map['lastMessage'] as String,
      lastMessageSender: map['lastMessageSender'] as String,
      lastMessageTimeSent: map['lastMessageTimeSent'] != null
          ? Timestamp.fromDate(
              DateTime.parse(map['lastMessageTimeSent'] as String))
          : null,
      lastMessageType: map['lastMessageType'] as String,
      membersId: List<dynamic>.from(
        (map['membersId'] as List<dynamic>),
      ),
      proctorId: map['proctorId'] as String,
      classId: map['classId'] as String,
      tuteeId: map['tuteeId'] as String,
      lastMessageId: map['lastMessageId'] as String,
    );
  }

  factory DirectMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return DirectMessageModel(
      chatId: doc['chatId'],
      timestamp: doc['createdAt'],
      lastMessage: doc['lastMessage'],
      lastMessageSender: doc['lastMessageSender'],
      lastMessageTimeSent: doc['lastMessageTimeSent'],
      lastMessageType: doc['lastMessageType'],
      membersId: doc['membersId'],
      proctorId: doc['proctorId'],
      classId: doc['classId'],
      tuteeId: doc['tuteeId'],
      lastMessageId: doc['lastMessageId'],
    );
  }
}
