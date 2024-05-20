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

  // get chat members whose notification is on
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
      final DocumentSnapshot<Map<String, dynamic>> membersSnapshot =
          await FirebaseFirestore.instance
              .collection("institution")
              .doc(institutionId)
              .collection("direct_messages")
              .doc(groupChatId)
              .get();
      List<String> membersList = [];

      if (membersSnapshot.exists) {
        Map<String, dynamic> data = membersSnapshot.data()!;
        if (data.containsKey("members")) {
          Map<String, dynamic> membersData = data["members"];
          membersData.forEach((key, value) {
            if (value is Map<String, dynamic> &&
                value.containsKey("receiveNotification") &&
                value["receiveNotification"] == true) {
              membersList.add(key); // Adding the user ID to membersList
            }
          });
        }
      }

      return membersList;
    }
  }

  // send chat message
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

    print("MEMBERS ID NOTIF: $membersIdNotif");
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

    print("LIST FCM TOKEN: $listfcmtoken");

    final List<String> nameParts = userName.split(' ');
    final String firstName = nameParts[0];
    final String format = firstName.substring(0, 1).toUpperCase() +
        firstName.substring(1).toLowerCase();

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

    if (isGroup) {
      // add new message to database
      DocumentReference newMessageRef = await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection('study_groups')
          .doc(groupChatid)
          .collection("messages")
          .add(
            newMessage.toMap(),
          );

      String messageId = newMessageRef.id;
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
          "lastMessageId": messageId,
        },
      );

      await updateUserLastMessageIdRead(
        groupChatid,
        institutionId,
        messageId,
        _firebaseAuth.currentUser!.uid,
        true,
      );

      for (String fcmtoken in listfcmtoken) {
        //send notification
        _firebaseMessage.sendPushMessage(
          recipientToken: fcmtoken,
          title: groupChatTitle,
          body: "$format: $message",
          route: 'groupchats',
        );
      }

      return true;
    } else {
      DocumentReference newMessageRef = await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection('direct_messages')
          .doc(groupChatid)
          .collection("messages")
          .add(
            newMessage.toMap(),
          );

      String messageId = newMessageRef.id;
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
          "lastMessageId": messageId,
        },
      );

      await updateUserLastMessageIdRead(
        groupChatid,
        institutionId,
        messageId,
        _firebaseAuth.currentUser!.uid,
        false,
      );

      for (String fcmtoken in listfcmtoken) {
        //send notification
        _firebaseMessage.sendPushMessage(
          recipientToken: fcmtoken,
          title: groupChatTitle,
          body: message,
          route: 'personal_chats',
        );
      }

      return true;
    }
  }

  // send announcement
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

    final userName = userInfodata!['name'];

    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String curreUserEmail = userName;

    final Timestamp timestamp = Timestamp.now();
    final DateTime date = DateTime.now();

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
      DocumentReference newMessageDocRef = await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection('study_groups')
          .doc(groupChatid)
          .collection("messages")
          .add(newMessage.toMap());

      String messageId = newMessageDocRef.id;

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
          'lastMessageId': messageId
        },
      );
      return true;
    } else {
      // add new message to database

      DocumentReference newMessageDocRef = await _firestore
          .collection("institution")
          .doc(institutionId)
          .collection('direct_messages')
          .doc(groupChatid)
          .collection("messages")
          .add(newMessage.toMap());

      String messageId = newMessageDocRef.id;
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
          'lastMessageId': messageId
        },
      );

      await updateUserLastMessageIdRead(
        groupChatid,
        institutionId,
        messageId,
        _firebaseAuth.currentUser!.uid,
        false,
      );
      return true;
    }
  }

  // send content
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

  // update the user last message read
  Future<void> updateUserLastMessageIdRead(
    String groupChatId,
    String institutionId,
    String messageId,
    String userId,
    bool isGroup,
  ) async {
    if (isGroup) {
      _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .doc(groupChatId)
          .collection("members")
          .doc(userId)
          .update(
        {
          'lastMessageIdRead': messageId,
        },
      );
    } else {
      _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("direct_messages")
          .doc(groupChatId)
          .update(
        {
          'members.$userId.lastMessageIdRead': messageId,
        },
      );
    }
  }
}
