import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/structure/models/chat_model.dart';
import 'package:nylo/structure/services/user_service.dart';

class ChatService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserInformation _users = UserInformation();
  final FirebaseMessage _firebaseMessage = FirebaseMessage();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Future<List<String>> membersWithNotificationOn(
    String groupChatId,
    String institutionId,
    bool isGroupChat,
  ) async {
    if (isGroupChat) {
      final QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .doc(groupChatId)
          .collection("members")
          .where("receiveNotification", isEqualTo: true)
          .get();

      List<String> membersList = [];

      // Extract member IDs from the snapshot
      for (var doc in membersSnapshot.docs) {
        membersList.add(doc.id);
      }

      return membersList;
    } else {
      final QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
          .collection("institution")
          .doc(institutionId)
          .collection("direct_messages")
          .doc(groupChatId)
          .collection("members")
          .where("receiveNotification", isEqualTo: true)
          .get();

      List<String> membersList = [];

      // Extract member IDs from the snapshot
      for (var doc in membersSnapshot.docs) {
        membersList.add(doc.id);
      }

      return membersList;
    }
  }

  Future<bool> sendMessage(
    String groupChatid,
    String message,
    String type,
    String downloadUrl,
    String institutionId,
    String groupChatTitle,
    String category,
    String filename,
    bool isGroup,
  ) async {
    // current user Info
    final userInfo =
        await _users.getUserInfo(_firebaseAuth.currentUser!.uid, institutionId);

    final userInfodata = userInfo.data();
    print("userInfodata: $userInfodata");

    final userName = userInfodata!['name'];

    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String curreUserEmail = userName;

    final Timestamp timestamp = Timestamp.now();

    // get all members where Notification = true
    final membersIdNotif = await membersWithNotificationOn(
      groupChatid,
      institutionId,
      isGroup,
    );
    print("membersIdNotif: $membersIdNotif");

    // get all their FCM token
    final listfcmtoken = [];

    for (String memberId in membersIdNotif) {
      // Skip adding the token if it belongs to the current user
      if (memberId == _firebaseAuth.currentUser!.uid) {
        continue;
      }

      // Get user info for the member
      final userInfo = await _users.getUserInfo(memberId, institutionId);
      // Assuming user info contains fcmtoken
      final userfcmToken = userInfo['fcmtoken'];
      // Add the FCM token to the list
      listfcmtoken.add(userfcmToken);
    }

    print("listfcmtoken: $listfcmtoken");

    final List<String> nameParts = userName.split(' ');
    final String firstName = nameParts[0];
    final String format = firstName.substring(0, 1).toUpperCase() +
        firstName.substring(1).toLowerCase();
    for (String fcmtoken in listfcmtoken) {
      //send notification
      _firebaseMessage.sendPushMessage(
          recipientToken: fcmtoken,
          title: groupChatTitle,
          body: "$format: $message");
    }

    // create a new message
    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      groupChatId: groupChatid,
      message: message,
      timestamp: timestamp,
      type: type,
      downloadUrl: downloadUrl,
      category: category,
      filename: filename,
    );
    print("IS GROUP: $isGroup");
    if (isGroup) {
// add new message to database
      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection('study_groups')
          .doc(groupChatid)
          .collection("messages")
          .add(newMessage.toMap());

      // add GroupChat LastMessage, LastMessageSender, and LastMessageTimeSent
      _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .doc(groupChatid)
          .update(
        {
          "lastMessage": message,
          "lastMessageSender": curreUserEmail,
          "lastMessageTimeSent": timestamp,
          "lastMessageType": type,
        },
      );
      return true;
    } else {
      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection('direct_messages')
          .doc(groupChatid)
          .collection("messages")
          .add(newMessage.toMap());

      // add GroupChat LastMessage, LastMessageSender, and LastMessageTimeSent
      _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("direct_messages")
          .doc(groupChatid)
          .update(
        {
          "lastMessage": message,
          "lastMessageSender": curreUserEmail,
          "lastMessageTimeSent": timestamp,
          "lastMessageType": type,
        },
      );

      return true;
    }
  }

  Future<bool> sendAnnouncementMessage(
    String groupChatid,
    String message,
    String type,
    String downloadUrl,
    String institutionId,
    bool isGroupChat,
  ) async {
    // current user Info
    final userInfo =
        await _users.getUserInfo(_firebaseAuth.currentUser!.uid, institutionId);

    final userInfodata = userInfo.data();
    print("userInfodata: $userInfodata");

    final userName = userInfodata!['name'];

    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String curreUserEmail = userName;

    final Timestamp timestamp = Timestamp.now();

    // create a new message
    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      groupChatId: groupChatid,
      message: message,
      timestamp: timestamp,
      type: type,
      downloadUrl: downloadUrl,
      category: '',
      filename: '',
    );

    if (isGroupChat) {
      // add new message to database
      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection('study_groups')
          .doc(groupChatid)
          .collection("messages")
          .add(newMessage.toMap());

      // add GroupChat LastMessage, LastMessageSender, and LastMessageTimeSent
      _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .doc(groupChatid)
          .update(
        {
          "lastMessage": message,
          "lastMessageSender": curreUserEmail,
          "lastMessageTimeSent": timestamp,
          "lastMessageType": type,
        },
      );
      return true;
    } else {
      // add new message to database
      await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection('direct_messages')
          .doc(groupChatid)
          .collection("messages")
          .add(newMessage.toMap());

      // add GroupChat LastMessage, LastMessageSender, and LastMessageTimeSent
      _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("direct_messages")
          .doc(groupChatid)
          .update(
        {
          "lastMessage": message,
          "lastMessageSender": curreUserEmail,
          "lastMessageTimeSent": timestamp,
          "lastMessageType": type,
        },
      );
      return true;
    }
  }

  Future<bool> sendContentMessage(
    String filePath,
    String fileName,
    String groupChatid,
    String message,
    String type,
    String category,
    String groupChatTitle,
    String institutionId,
    bool isGroup,
  ) async {
    print("IS GROUP: $isGroup");
    try {
      File file = File(filePath);
      await _firebaseStorage.ref('chatImages/$fileName').putFile(file);
      String downloadUrl =
          await _firebaseStorage.ref('chatImages/$fileName').getDownloadURL();

      // if image
      if (category == "image") {
        await sendMessage(
          groupChatid,
          message,
          type,
          downloadUrl,
          institutionId,
          groupChatTitle,
          "image",
          fileName,
          isGroup,
        );
        return true;

        // if document
      } else {
        await sendMessage(
          groupChatid,
          message,
          type,
          downloadUrl,
          institutionId,
          groupChatTitle,
          "document",
          fileName,
          isGroup,
        );
        return true;
      }
    } on FirebaseException catch (e) {
      return false;
    }
  }
}
