// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String groupChatId;
  final String message;
  final Timestamp timestamp;
  final String type;
  final String? downloadUrl;
  final String? category;
  final String? filename;
  final DateTime? date;

  MessageModel({
    required this.senderId,
    required this.groupChatId,
    required this.message,
    required this.timestamp,
    required this.type,
    this.downloadUrl,
    this.category,
    this.filename,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'groupChatId': groupChatId,
      'message': message,
      'timestamp': timestamp,
      'type': type,
      'downloadUrl': downloadUrl,
      'category': category,
      'filename': filename,
      'date': date!.millisecondsSinceEpoch
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      groupChatId: map['groupChatId'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp']
          as Timestamp, // Timestamp.fromDate(DateTime.parse(map['timestamp'] as String)),
      type: map['type'] as String,
      downloadUrl: map['downloadUrl'] as String,
      category: map['category'] as String,
      filename: map['filename'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  factory MessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return MessageModel(
      senderId: doc['senderId'],
      groupChatId: doc['groupChatId'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      type: doc['type'],
      downloadUrl: doc['downloadUrl'],
      category: doc['category'],
      filename: doc['filename'],
      date: DateTime.fromMillisecondsSinceEpoch(doc['date'] as int),
    );
  }
}
