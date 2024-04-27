// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// GROUPCHAT MODEL
final FirebaseAuth _auth = FirebaseAuth.instance;

class GroupChatModel {
  final String docID;
  final String creatorId;
  final String creatorName;
  final String studyGroupTitle;
  final String studyGroupDescription;
  final String studyGroupCourseName;
  final String studyGroupCourseId;
  final Timestamp timestamp;
  final List<dynamic> membersId;

  final List<dynamic> membersRequestId;
  final String lastMessage;
  final String lastMessageSender;
  final Timestamp? lastMessageTimeSent;
  final String lastMessageType;
  final String? groupChatImage;
  final String courseTitle;
  final String lastMessageId;

  GroupChatModel({
    required this.docID,
    required this.creatorId,
    required this.creatorName,
    required this.studyGroupTitle,
    required this.studyGroupDescription,
    required this.studyGroupCourseName,
    required this.studyGroupCourseId,
    required this.timestamp,
    required this.membersId,
    required this.membersRequestId,
    required this.lastMessage,
    required this.lastMessageSender,
    required this.lastMessageTimeSent,
    required this.lastMessageType,
    this.groupChatImage,
    required this.courseTitle,
    required this.lastMessageId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': docID,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'studyGroupTitle': studyGroupTitle,
      'studyGroupDescription': studyGroupDescription,
      'studyGroupCourseName': studyGroupCourseName,
      'studyGroupCourseId': studyGroupCourseId,
      'createdAt': timestamp,
      'membersId': membersId,
      'membersRequestId': membersRequestId,
      'lastMessage': lastMessage,
      'lastMessageSender': lastMessageSender,
      'lastMessageTimeSent': lastMessageTimeSent,
      'lastMessageType': lastMessageType,
      'groupChatImage': groupChatImage,
      'courseTitle': courseTitle,
      'lastMessageId': lastMessageId,
    };
  }

  // ),
  factory GroupChatModel.fromMap(Map<String, dynamic> map) {
    return GroupChatModel(
      docID: map['docID'] as String,
      creatorId: map['creatorId'] as String,
      creatorName: map['creatorName'] as String,
      studyGroupTitle: map['studyGroupTitle'] as String,
      studyGroupDescription: map['studyGroupDescription'] as String,
      studyGroupCourseName: map['studyGroupCourseName'] as String,
      studyGroupCourseId: map['studyGroupCourseId'] as String,
      timestamp: Timestamp.fromDate(DateTime.parse(map['createdAt'] as String)),
      membersId: List<dynamic>.from((map['membersId'] as List<dynamic>)),
      membersRequestId:
          List<dynamic>.from((map['membersRequestId'] as List<dynamic>)),
      lastMessage: map['lastMessage'] as String,
      lastMessageSender: map['lastMessageSender'] as String,
      lastMessageTimeSent: map['lastMessageTimeSent'] != null
          ? Timestamp.fromDate(
              DateTime.parse(map['lastMessageTimeSent'] as String))
          : null,
      lastMessageType: map['lastMessageType'] as String,
      groupChatImage: map['groupChatImage'] != null
          ? map['groupChatImage'] as String
          : null,
      courseTitle: map['studyGroupTitle'] as String,
      lastMessageId: map['lastMessageId'] as String,
    );
  }

  factory GroupChatModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return GroupChatModel(
      docID: doc['chatId'],
      creatorId: doc['creatorId'],
      creatorName: doc['creatorName'],
      studyGroupTitle: doc['studyGroupTitle'],
      studyGroupDescription: doc['studyGroupDescription'],
      studyGroupCourseName: doc['studyGroupCourseName'],
      studyGroupCourseId: doc['studyGroupCourseId'],
      timestamp: doc['createdAt'],
      membersId: doc['membersId'],
      membersRequestId: doc['membersRequestId'],
      lastMessage: doc['lastMessage'],
      lastMessageSender: doc['lastMessageSender'],
      lastMessageTimeSent: doc['lastMessageTimeSent'],
      lastMessageType: doc['lastMessageType'],
      groupChatImage: doc['groupChatImage'],
      courseTitle: doc['courseTitle'],
      lastMessageId: doc['lastMessageId'],
    );
  }
}
