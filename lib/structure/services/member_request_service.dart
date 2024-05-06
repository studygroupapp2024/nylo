import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/structure/models/chat_members_model.dart';
import 'package:nylo/structure/services/chat_services.dart';
import 'package:nylo/structure/services/user_service.dart';

class MemberRequest {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseMessage _firebaseMessage = FirebaseMessage();
  final UserInformation _users = UserInformation();
  final ChatService _chatService = ChatService();
  // request to join
  Future<void> requestToJoin(
    String chatId,
    String ownerId,
    String groupChatTitle,
    String institutionId,
    String userId,
  ) async {
    // get the owner's data
    final getOwnerData = await _users.getUserInfo(ownerId, institutionId);

    final ownerData = getOwnerData.data();

    final ownerfcm = ownerData!['fcmtoken'];

    // get the current user's data
    final getCurrentUserData = await _users.getUserInfo(userId, institutionId);

    final requestorName = getCurrentUserData['name'];

    // send notification to the owner
    _firebaseMessage.sendPushMessage(
      recipientToken: ownerfcm,
      title: "Member Request Notification",
      body: "$groupChatTitle: $requestorName wants to join your study group.",
      route: 'groupchats',
    );

    // add the study group to the user study group.
    await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("study_groups")
        .doc(chatId)
        .update({
      'membersRequestId': FieldValue.arrayUnion([userId]),
    });
  }

  // Update the Study Group Member List
  Future<void> acceptOrreject(
    String documentId,
    String userId,
    bool isAccepted,
    String title,
    String institutionId,
  ) async {
    final Timestamp timestamp = Timestamp.now();
    final userInfo = await _users.getUserInfo(userId, institutionId);

    final userInfodata = userInfo.data();

    final uid = userInfodata!['uid'];
    final userName = userInfodata['name'];

    final fcmtoken = userInfodata['fcmtoken'];

    if (isAccepted) {
      // create a new Member
      ChatMembersModel newMember = ChatMembersModel(
          lastReadChat: timestamp,
          userId: uid,
          isAdmin: false,
          receiveNotification: true);

      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .doc(documentId)
          .collection("members")
          .doc(userId)
          .set(
            newMember.toMap(),
          );

      // send notification
      _firebaseMessage.sendPushMessage(
        recipientToken: fcmtoken,
        title: "Welcome!",
        body: "Your request to join $title has been accepted.",
        route: 'groupchats',
      );
      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .doc(documentId)
          .update(
        {
          'membersId': FieldValue.arrayUnion(
            [userId],
          ),
        },
      );

      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .doc(documentId)
          .update(
        {
          'membersRequestId': FieldValue.arrayRemove(
            [userId],
          ),
        },
      );

      // add the study group to the user groups.
      var data = {
        "groupChatId": documentId,
      };
      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("students")
          .doc(userId)
          .collection("groupChats")
          .doc(documentId)
          .set(data);

      // add message to the group chat
      var type = "announcement";
      var message = "$userName has joined the study group.";

      await _chatService.sendAnnouncementMessage(
        documentId,
        message,
        type,
        "",
        institutionId,
        true,
      );
    } else {
      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .doc(documentId)
          .update(
        {
          'membersRequestId': FieldValue.arrayRemove(
            [userId],
          ),
        },
      );
      // send notification
      _firebaseMessage.sendPushMessage(
        recipientToken: fcmtoken,
        title: "Notice",
        body: "Your request to join $title has been rejected.",
        route: 'groupchats',
      );
    }
  }
}
