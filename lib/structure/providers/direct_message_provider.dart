import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/chat_members_model.dart';
import 'package:nylo/structure/models/chat_model.dart';
import 'package:nylo/structure/models/direct_message_model.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/direct_message_services.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final directMessageProvider = StateProvider.autoDispose<DirectMessage>((ref) {
  return DirectMessage();
});

// get User Study Groups
final tutorDirectMessages =
    StreamProvider.family<List<DirectMessageModel>, String>(
  (ref, userId) {
    final institutionId = ref.watch(setGlobalUniversityId);
    final userStudyGroups = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("direct_messages")
        .where("proctorId", isNotEqualTo: userId)
        .orderBy("proctorId", descending: true)
        .orderBy("lastMessageTimeSent", descending: true)
        .orderBy("__name__", descending: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (snapshot) => DirectMessageModel.fromSnapshot(snapshot),
              )
              .where(
                (group) => group.membersId.contains(userId),
              )
              .toList(),
        );
    return userStudyGroups;
  },
);

final tuteeDirectMessages =
    StreamProvider.family<List<DirectMessageModel>, String>(
  (ref, userId) {
    final institutionId = ref.watch(setGlobalUniversityId);
    final userStudyGroups = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("direct_messages")
        .where("proctorId", isEqualTo: userId)
        .orderBy("proctorId", descending: true)
        .orderBy("lastMessageTimeSent", descending: true)
        .orderBy("__name__", descending: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (snapshot) => DirectMessageModel.fromSnapshot(snapshot),
              )
              .where(
                (group) => group.membersId.contains(userId),
              )
              .toList(),
        );
    return userStudyGroups;
  },
);

final tutorClassMessagesProvider =
    StreamProvider.family.autoDispose<List<MessageModel>, String>(
  (ref, chatId) {
    final institutionId = ref.watch(setGlobalUniversityId);
    final chats = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("direct_messages")
        .doc(chatId)
        .collection("messages")
        .limit(5)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (chats) => MessageModel.fromSnapshot(chats),
              )
              .toList(),
        );
    return chats;
  },
);

final directMessageMemberInfoProvider =
    StreamProvider.family.autoDispose<ChatMembersModel, String>((ref, chatId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final document = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("direct_messages")
      .doc(chatId)
      .collection("members")
      .doc(_auth.currentUser!.uid);
  return document.snapshots().map(
        ChatMembersModel.fromSnapshot,
      );
});

final directMessageInfoProvider =
    StreamProvider.family<SubjectMatterModel, String>((ref, subjectMatterId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final document = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("subject_matters")
      .doc(subjectMatterId);
  return document.snapshots().map(
        (snapshot) => SubjectMatterModel.fromSnapshot(snapshot),
      );
});
