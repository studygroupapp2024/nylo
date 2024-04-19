import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/subject_matter_services.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final subjectMatterProvider = StateProvider.autoDispose<SubjectMatter>((ref) {
  return SubjectMatter();
});

final selectedClassInformationProvider = StreamProvider.family
    .autoDispose<List<SubjectMatterModel>, String>((ref, userId) {
  final searchQuery = ref.watch(findTutorSearchQueryProvider);
  final subjectMattersTaken = ref.watch(subjectMatterIdProvider(userId)).value;

  print("subjectMattersTaken: $subjectMattersTaken");
  final institutionId = ref.watch(setGlobalUniversityId);

  final getStudyGroups = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("subject_matters")
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map((snapshot) => SubjectMatterModel.fromSnapshot(snapshot))
            .where((group) =>
                !subjectMattersTaken!.contains(group.classId) &&
                (group.courseTitles
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    group.courseCodes
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    searchQuery.isEmpty))
            .toList(),
      );

  return getStudyGroups;
});

// Subject Matters Taken
final subjectMatterIdProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  return _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("students")
      .doc(userId)
      .collection("subject_matters")
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => doc.data()['classId'] as String)
          .toList());
});

final findTutorSearchQueryProvider = StateProvider<String>((ref) => '');

final findTutorSearchQueryLengthProvider = StateProvider<int>((ref) => 0);
