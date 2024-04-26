import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/subject_model.dart';

class SubjectRepository {
  SubjectRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  final FirebaseFirestore _firestore;

  fetchSubjects({
    required int pageSize,
    DocumentSnapshot? lastDoc,
    required String institutionId,
  }) async {
    final initialQuery = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subjects")
        .limit(15);

    final query = lastDoc != null
        ? initialQuery.startAfterDocument(lastDoc)
        : initialQuery;

    final snapshot = await query.get();
    final docs = snapshot.docs;
    final result = docs.map((doc) => SubjectModel.fromMap(doc.data())).toList();
    return (result, docs.last);
  }
}

final appSubjectRepositoryProvider = Provider(
  (ref) => SubjectRepository(
    firestore: FirebaseFirestore.instance,
  ),
);
