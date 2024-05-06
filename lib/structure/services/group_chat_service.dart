import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/structure/models/chat_members_model.dart';
import 'package:nylo/structure/models/group_chat_model.dart';
import 'package:nylo/structure/services/chat_services.dart';
import 'package:nylo/structure/services/user_service.dart';

class GroupChat {
  final institution = FirebaseFirestore.instance.collection("institution");
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserInformation _users = UserInformation();
  final ChatService _chatService = ChatService();
  final FirebaseMessage _firebaseMessage = FirebaseMessage();

  Future<void> configureNotification(String groupChatId, String institutionId,
      String userId, bool receiveNotification, bool isGroup) async {
    if (isGroup) {
      await institution
          .doc(institutionId)
          .collection("study_groups")
          .doc(groupChatId)
          .collection("members")
          .doc(userId)
          .update({
        'receiveNotification': receiveNotification,
      });
    } else {
      await institution
          .doc(institutionId)
          .collection("direct_messages")
          .doc(groupChatId)
          .collection("members")
          .doc(userId)
          .update({
        'receiveNotification': receiveNotification,
      });
    }
  }

  // delete study group
  Future<void> removeStudyGroup(
    String groupChatId,
    String institutionId,
    String userId,
  ) async {
    // remove the study group
    await institution
        .doc(institutionId)
        .collection("study_groups")
        .doc(groupChatId)
        .delete();

    // remove the study group from the user
    await institution
        .doc(institutionId)
        .collection("students")
        .doc(userId)
        .collection("groupChats")
        .doc(groupChatId)
        .delete();
  }

  // add study group
  Future<bool> addStudyGroup(
    String title,
    String description,
    String course,
    String courseId,
    String courseTitle,
    String institutionId,
    String filePath,
    String filename,
  ) async {
    // get student data
    final userInfo =
        await _users.getUserInfo(_auth.currentUser!.uid, institutionId);

    final userInfodata = userInfo.data();

    final userName = userInfodata!['name'];

    try {
      if (title.isNotEmpty && description.isNotEmpty && course.isNotEmpty) {
        if (filePath.isNotEmpty && filename.isNotEmpty) {
          final Timestamp timestamp = Timestamp.now();

          print("file");
          File file = File(filePath);

          // Upload the file to the 'profileImages' path
          await _firebaseStorage
              .ref('groupChatHeaders/$filename')
              .putFile(file);

          // Retrieve the download URL from the same path where the file was uploaded
          String downloadUrl = await _firebaseStorage
              .ref(
                  'groupChatHeaders/$filename') // Use the same path for consistency
              .getDownloadURL();

          GroupChatModel newGroupChat = GroupChatModel(
            docID: '',
            creatorId: _auth.currentUser!.uid,
            creatorName: userName,
            studyGroupTitle: title,
            studyGroupDescription: description,
            studyGroupCourseName: course,
            studyGroupCourseId: courseId,
            timestamp: timestamp,
            membersId: [_auth.currentUser!.uid],
            membersRequestId: [],
            lastMessageId: '',
            lastMessage: '',
            lastMessageSender: '',
            lastMessageTimeSent: null,
            lastMessageType: '',
            groupChatImage: downloadUrl,
            courseTitle: courseTitle,
          );

          // create a new study group
          ChatMembersModel newMemberList = ChatMembersModel(
            lastReadChat: null,
            userId: _auth.currentUser!.uid,
            isAdmin: true,
            receiveNotification: true,
          );

          // groupChat.add(newGroupChat.toMap());
          // add new study group to the database database
          DocumentReference newGroupChatRef = await institution
              .doc(institutionId)
              .collection("study_groups")
              .add(
                newGroupChat.toMap(),
              );

          String groupChatId = newGroupChatRef.id;

          institution
              .doc(institutionId)
              .collection("study_groups")
              .doc(groupChatId)
              .update({'chatId': groupChatId});

          await institution
              .doc(institutionId)
              .collection("study_groups")
              .doc(groupChatId)
              .collection("members")
              .doc(_auth.currentUser!.uid)
              .set(
                newMemberList.toMap(),
              );

          // Add the group chat to the user's study group chat

          var data = {
            "groupChatId": groupChatId,
          };
          await institution
              .doc(institutionId)
              .collection("students")
              .doc(_auth.currentUser!.uid)
              .collection("groupChats")
              .doc(groupChatId)
              .set(data);

          var type = "announcement";
          var message = "$userName has created the study group.";
          await _chatService.sendAnnouncementMessage(
            groupChatId,
            message,
            type,
            "",
            institutionId,
            true,
          );
          return true;
        } else {
          final Timestamp timestamp = Timestamp.now();
          GroupChatModel newGroupChat = GroupChatModel(
            docID: '',
            creatorId: _auth.currentUser!.uid,
            creatorName: userName,
            studyGroupTitle: title,
            studyGroupDescription: description,
            studyGroupCourseName: course,
            studyGroupCourseId: courseId,
            timestamp: timestamp,
            membersId: [_auth.currentUser!.uid],
            membersRequestId: [],
            lastMessage: '',
            lastMessageSender: '',
            lastMessageId: '',
            lastMessageTimeSent: null,
            lastMessageType: '',
            groupChatImage: '',
            courseTitle: courseTitle,
          );

          // create a new study group
          ChatMembersModel newMemberList = ChatMembersModel(
            lastReadChat: null,
            userId: _auth.currentUser!.uid,
            isAdmin: true,
            receiveNotification: true,
          );

          // groupChat.add(newGroupChat.toMap());
          // add new study group to the database database
          DocumentReference newGroupChatRef = await institution
              .doc(institutionId)
              .collection("study_groups")
              .add(
                newGroupChat.toMap(),
              );

          String groupChatId = newGroupChatRef.id;

          await institution
              .doc(institutionId)
              .collection("study_groups")
              .doc(groupChatId)
              .update({'chatId': groupChatId});

          await institution
              .doc(institutionId)
              .collection("study_groups")
              .doc(groupChatId)
              .collection("members")
              .doc(_auth.currentUser!.uid)
              .set(
                newMemberList.toMap(),
              );

          // Add the group chat to the user's study group chat

          var data = {
            "groupChatId": groupChatId,
          };
          await institution
              .doc(institutionId)
              .collection("students")
              .doc(_auth.currentUser!.uid)
              .collection("groupChats")
              .doc(groupChatId)
              .set(data);

          var type = "announcement";
          var message = "$userName has created the study group.";
          await _chatService.sendAnnouncementMessage(
              groupChatId, message, type, "", institutionId, true);
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // remove a member
  Future<void> removeMember(
    String groupChatId,
    String userId,
    String institutionId,
    String way,
    String memberName,
    String groupChatTitle,
    String creatorId,
  ) async {
    // remove the member from the group
    await institution
        .doc(institutionId)
        .collection("study_groups")
        .doc(groupChatId)
        .collection("members")
        .doc(userId)
        .delete();

    // remove the group chat from the user's study group chat
    await institution
        .doc(institutionId)
        .collection("students")
        .doc(userId)
        .collection("groupChats")
        .doc(groupChatId)
        .delete();

    // remove the user from the group
    await institution
        .doc(institutionId)
        .collection("study_groups")
        .doc(groupChatId)
        .update(
      {
        "membersId": FieldValue.arrayRemove(
          [userId],
        )
      },
    );

    // get user data
    final userInfo = await _users.getUserInfo(
      userId,
      institutionId,
    );

    final userInfodata = userInfo.data();

    final fcmtoken = userInfodata!['fcmtoken'];
    // send message to the group chat

    // get user data
    final ownerUserInfo = await _users.getUserInfo(
      creatorId,
      institutionId,
    );

    final ownerUserInfodata = ownerUserInfo.data();

    final ownerfcmtoken = ownerUserInfodata!['fcmtoken'];
    // send message to the group chat

    var type = "announcement";

    if (way == "left") {
      var message = "$memberName has left the study group.";

      await _chatService.sendAnnouncementMessage(
          groupChatId, message, type, "", institutionId, true);

      // Send notification to the owner that a member of his group has left
      await _firebaseMessage.sendPushMessage(
        recipientToken: ownerfcmtoken,
        title: "Notice",
        body: message,
        route: 'groupchats',
      );
    } else {
      var message = "$memberName has been removed from the study group.";

      await _chatService.sendAnnouncementMessage(
        groupChatId,
        message,
        type,
        "",
        institutionId,
        true,
      );

      await _firebaseMessage.sendPushMessage(
        recipientToken: fcmtoken,
        title: "Notice",
        body: "You have been removed from the $groupChatTitle.",
        route: 'groupchats',
      );
    }
  }

  //Change groupChat profile
  Future<void> changeGroupChatProfile(
    String filePath,
    String filename,
    String groupChatId,
    String institutionId,
  ) async {
    File file = File(filePath);
    try {
      await _firebaseStorage.ref('chatImages/$filename').putFile(file);
      String downloadUrl =
          await _firebaseStorage.ref('chatImages/$filename').getDownloadURL();

      await institution
          .doc(institutionId)
          .collection("study_groups")
          .doc(groupChatId)
          .update({"groupChatImage": downloadUrl});
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
