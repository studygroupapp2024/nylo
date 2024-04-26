import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/chat_model.dart';

class ChatRepository {
  ChatRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  final FirebaseFirestore _firestore;

  fetchTutorChats({
    required int pageSize,
    DocumentSnapshot? lastDoc,
    required String institutionId,
  }) async {
    final initialQuery = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("direct_messages")
        .doc("dK68i0ZK3fMwd2cxv1T6")
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(15);

    final query = lastDoc != null
        ? initialQuery.startAfterDocument(lastDoc)
        : initialQuery;

    final snapshot = await query.get();
    final docs = snapshot.docs;
    final result = docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
    return (result, docs.last);
  }
}

final tutorAppSubjectRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
  ),
);
