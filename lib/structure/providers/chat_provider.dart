// get User Study Groups
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/chat_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/chat_services.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final studyGroupMessageProvider =
    StreamProvider.family<List<MessageModel>, String>(
  (ref, chatId) {
    final institutionId = ref.watch(setGlobalUniversityId);
    final chats = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("study_groups")
        .doc(chatId)
        .collection("messages")
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

// ====================== STATE PROVIDERS ===================

final chatProvider = StateProvider<ChatService>((ref) {
  return ChatService();
});
