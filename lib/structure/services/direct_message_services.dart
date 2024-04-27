import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nylo/structure/models/chat_members_model.dart';
import 'package:nylo/structure/models/direct_message_model.dart';
import 'package:nylo/structure/services/chat_services.dart';
import 'package:nylo/structure/services/user_service.dart';

class DirectMessage {
  final institution = FirebaseFirestore.instance.collection("institution");

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserInformation _users = UserInformation();
  final ChatService _chatService = ChatService();

  // create a Direct Message
  Future<Map<String, dynamic>> addDirectMessage(
    String institutionId,
    String proctorId,
    String subjectMatterId,
  ) async {
    //get student data
    final userInfo =
        await _users.getUserInfo(_auth.currentUser!.uid, institutionId);

    final userInfodata = userInfo.data();

    final userName = userInfodata!['name'];
    final proctorInfo = await _users.getUserInfo(proctorId, institutionId);
    final proctorInfoData = proctorInfo.data();

    final proctorName = proctorInfoData!['name'];
    try {
      final Timestamp timestamp = Timestamp.now();

      DirectMessageModel newDirectMessage = DirectMessageModel(
        timestamp: timestamp,
        lastMessage: '',
        lastMessageSender: '',
        lastMessageTimeSent: null,
        lastMessageType: '',
        membersId: [proctorId, _auth.currentUser!.uid],
        proctorId: proctorId,
        classId: subjectMatterId,
        tuteeId: _auth.currentUser!.uid,
      );

      DocumentReference newDirectMessageRef = await institution
          .doc(institutionId)
          .collection("direct_messages")
          .add(
            newDirectMessage.toMap(),
          );

      String directMessageId = newDirectMessageRef.id;

      await institution
          .doc(institutionId)
          .collection("direct_messages")
          .doc(directMessageId)
          .update({'chatId': directMessageId});

      // Add the user and the proctor to the members of the direct message
      ChatMembersModel addUserAsMember = ChatMembersModel(
        lastReadChat: timestamp,
        userId: _auth.currentUser!.uid,
        isAdmin: false,
        receiveNotification: true,
      );

      await institution
          .doc(institutionId)
          .collection("direct_messages")
          .doc(directMessageId)
          .collection("members")
          .doc(_auth.currentUser!.uid)
          .set(
            addUserAsMember.toMap(),
          );

      ChatMembersModel addProctorAsMember = ChatMembersModel(
        lastReadChat: timestamp,
        userId: proctorId,
        isAdmin: true,
        receiveNotification: true,
      );

      await institution
          .doc(institutionId)
          .collection("direct_messages")
          .doc(directMessageId)
          .collection("members")
          .doc(proctorId)
          .set(
            addProctorAsMember.toMap(),
          );

      // Add the group chat to the user's subject matter
      var data = {
        "classId": subjectMatterId,
      };

      await institution
          .doc(institutionId)
          .collection("students")
          .doc(_auth.currentUser!.uid)
          .collection("subject_matters")
          .doc(subjectMatterId)
          .set(data);

      // Add the class to the proctor's direct messages
      var setDirectMessageId = {
        "directMessageId": directMessageId,
      };
      await institution
          .doc(institutionId)
          .collection("students")
          .doc(proctorId)
          .collection("direct_messages")
          .doc(directMessageId)
          .set(setDirectMessageId);

      // Add the class to the student's direct messages
      await institution
          .doc(institutionId)
          .collection("students")
          .doc(_auth.currentUser!.uid)
          .collection("direct_messages")
          .doc(directMessageId)
          .set(setDirectMessageId);

      // Send a message to the direct message
      var type = "announcement";
      var message = "$userName has created the study group.";
      await _chatService.sendAnnouncementMessage(
        directMessageId,
        message,
        type,
        "",
        institutionId,
        false,
      );

      Map<String, dynamic> createMap() {
        Map<String, dynamic> myMap = {
          'directMessageId': directMessageId,
          'title': proctorName,
          'creator': proctorId,
          'dateCreated': timestamp.toString(),
          'membersId': [proctorId, _auth.currentUser!.uid],
          'classId': subjectMatterId,
          'isSuccess': true,
          // Add more key-value pairs as needed
        };

        return myMap;
      }

      return createMap();
    } catch (e) {
      Map<String, dynamic> createMap() {
        Map<String, dynamic> myMap = {
          'directMessageId': '',
          'title': '',
          'creator': '',
          'dateCreated': '',
          'membersId': [],
          'classId': '',
          'isSuccess': false,
          // Add more key-value pairs as needed
        };

        return myMap;
      }

      return createMap();
    }
  }
}
