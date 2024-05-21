// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nylo/structure/services/subject_matter_services.dart';

class Member {
  final bool isAdmin;
  final bool receiveNotification;
  final String? lastMessageIdRead;
  final String id;
  final String imageUrl;
  final String name;
  Member({
    required this.isAdmin,
    required this.receiveNotification,
    this.lastMessageIdRead,
    required this.id,
    required this.imageUrl,
    required this.name,
  });
}

class ChatMembers {
  final bool isAdmin;
  final bool receiveNotification;
  final String? lastMessageIdRead;
  final String imageUrl;
  final String name;

  ChatMembers({
    required this.isAdmin,
    required this.receiveNotification,
    this.lastMessageIdRead,
    required this.imageUrl,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isAdmin': isAdmin,
      'receiveNotification': receiveNotification,
      'lastMessageIdRead': lastMessageIdRead,
      'imageUrl': imageUrl,
      'name': name
    };
  }

  factory ChatMembers.fromMap(Map<String, dynamic> map) {
    return ChatMembers(
      isAdmin: map['isAdmin'] as bool,
      receiveNotification: map['receiveNotification'] as bool,
      lastMessageIdRead: map['lastMessageIdRead'] != null
          ? map['lastMessageIdRead'] as String
          : null,
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
    );
  }
}

class MembersMap {
  Map<String, ChatMembers>? members;

  MembersMap({this.members});

  Map<String, dynamic> toMap() {
    return {
      'members': members!.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

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
  final Map<String, Subject>? subjects;
  final String className;
  final Map<String, ChatMembers>? members;
  final String classDescription;
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
    this.subjects,
    required this.className,
    this.members,
    required this.classDescription,
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
      'lastMessageId': lastMessageId,
      'subjects':
          subjects?.map((key, value) => MapEntry(key, value.toMap())) ?? {},
      'className': className,
      'members':
          members?.map((key, value) => MapEntry(key, value.toMap())) ?? {},
      'classDescription': classDescription
    };
  }

  factory DirectMessageModel.fromMap(Map<String, dynamic> map) {
    final subjectsMap = <String, Subject>{};

    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        subjectsMap[key] = Subject.fromMap(value);
      }
    });

    final membersMap = <String, ChatMembers>{};
    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        membersMap[key] = ChatMembers.fromMap(value);
      }
    });

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
      subjects: subjectsMap,
      className: map['className'] as String,
      members: membersMap,
      classDescription: map['classDescription'] as String,
    );
  }

  factory DirectMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final subjectsMap = doc.data()?['subjects'] as Map<String, dynamic>? ?? {};

    final membersMap = doc.data()?['members'] as Map<String, dynamic>? ?? {};

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
      subjects: subjectsMap.map((key, value) =>
          MapEntry(key, Subject.fromMap(value as Map<String, dynamic>))),
      className: doc['className'],
      members: membersMap.map((key, value) =>
          MapEntry(key, ChatMembers.fromMap(value as Map<String, dynamic>))),
      classDescription: doc['classDescription'],
    );
  }
}
