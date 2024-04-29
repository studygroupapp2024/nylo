import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/chat_members_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

final singleMemberTutorChatInformationProvider =
    StreamProvider.family<ChatMembersModel, String>((ref, chatId) {
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
