import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/structure/models/chat_members_model.dart';
import 'package:nylo/structure/models/direct_message_model.dart';
import 'package:nylo/structure/services/chat_services.dart';
import 'package:nylo/structure/services/user_service.dart';

class DirectMessage {
  final institution = FirebaseFirestore.instance.collection("institution");
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserInformation _users = UserInformation();
  final ChatService _chatService = ChatService();
  final FirebaseMessage _firebaseMessage = FirebaseMessage();

  // create a Direct Message
  Future<bool> addDirectMessage(
    String institutionId,
    String proctorId,
    String subjectMatterId,
  ) async {
    //get student data

    final userInfo =
        await _users.getUserInfo(_auth.currentUser!.uid, institutionId);

    final userInfodata = userInfo.data();
    print("userInfodata: $userInfodata");

    final userName = userInfodata!['name'];
    final imageUrl = userInfodata['imageUrl'];

    try {
      final Timestamp timestamp = Timestamp.now();

      DirectMessageModel newDirectMessage = DirectMessageModel(
        timestamp: timestamp,
        lastMessage: '',
        lastMessageSender: '',
        lastMessageTimeSent: null,
        lastMessageType: '',
      );

      // create a new study group
      ChatMembersModel newMemberList = ChatMembersModel(
        lastReadChat: '',
        userId: _auth.currentUser!.uid,
        imageUrl: imageUrl,
        name: userName,
        isAdmin: false,
        receiveNotification: true,
      );

      DocumentReference newDirectMessageRef = await institution
          .doc(institutionId)
          .collection("direct_messages")
          .add(
            newMemberList.toMap(),
          );

      String directMessageId = newDirectMessageRef.id;

      await institution
          .doc(institutionId)
          .collection("direct_messages")
          .doc(directMessageId)
          .update({'chatId': directMessageId});

      await institution
          .doc(institutionId)
          .collection("direct_messages")
          .doc(directMessageId)
          .collection("members")
          .doc(_auth.currentUser!.uid)
          .set(
            newMemberList.toMap(),
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

      await institution
          .doc(institutionId)
          .collection("students")
          .doc(_auth.currentUser!.uid)
          .collection("direct_messages")
          .doc(directMessageId)
          .set(setDirectMessageId);

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

      return true;
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }
}
