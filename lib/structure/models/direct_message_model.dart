import 'package:cloud_firestore/cloud_firestore.dart';

class DirectMessageModel {
  final String? chatId;
  final Timestamp timestamp;
  final String lastMessage;
  final String lastMessageSender;
  final Timestamp? lastMessageTimeSent;
  final String lastMessageType;

  DirectMessageModel({
    this.chatId,
    required this.timestamp,
    required this.lastMessage,
    required this.lastMessageSender,
    required this.lastMessageTimeSent,
    required this.lastMessageType,
  });
}
