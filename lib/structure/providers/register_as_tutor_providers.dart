import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';
import 'package:nylo/structure/models/subject_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final selectedCoursesToTeachProvider = StateNotifierProvider<
    SelectedCoursesToTeachNotifier, List<SelectedCoursesToTeachModel>>((ref) {
  return SelectedCoursesToTeachNotifier();
});

class SelectedCoursesToTeachNotifier
    extends StateNotifier<List<SelectedCoursesToTeachModel>> {
  SelectedCoursesToTeachNotifier() : super([]);

  void remove(SelectedCoursesToTeachModel courseToRemove) {
    state = [...state]..remove(courseToRemove);
  }

  void add(SelectedCoursesToTeachModel courseToAdd) {
    state = [...state, courseToAdd];
  }

  void clear() {
    state = [];
  }
}

typedef RemoveCourses = List<String>;

final removeCoursesProvider = StateProvider<RemoveCourses>((ref) {
  return [];
});

final classChatNameProvider = StateProvider<String?>((ref) => '');
final classChatDescriptionProvider = StateProvider<String?>((ref) => '');

final classButtonColorProvider = StateProvider<bool>((ref) {
  final selectedCourse = ref.watch(selectedCoursesToTeachProvider);
  final chatName = ref.watch(classChatNameProvider);
  final chatDescription = ref.watch(classChatDescriptionProvider);
//selectedCourse!.isNotEmpty &&
  return (chatName!.isNotEmpty &&
      chatDescription!.isNotEmpty &&
      selectedCourse.isNotEmpty);
});

// get User Subject Matters
final userSubjectMatterProvider =
    StreamProvider.family<List<SubjectMatterModel>, String>(
  (ref, userId) {
    final institutionId = ref.watch(setGlobalUniversityId);
    final userSubjectMatter = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subject_matters")
        .where("proctorId", isEqualTo: userId)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (snapshot) => SubjectMatterModel.fromSnapshot(snapshot),
              )
              .toList(),
        );
    return userSubjectMatter;
  },
);

// Define a model for the user data
final getSubjectInfo =
    StreamProvider.family<SubjectModel, String>((ref, subjectId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final document = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("subjects")
      .doc(subjectId);

  return document.snapshots().map(
        (snapshot) => SubjectModel.fromSnapshot(snapshot),
      );
});
