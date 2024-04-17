import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';

class SubjectMatter {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final institution = FirebaseFirestore.instance.collection("institution");

  Future<bool> teachCourse(
    String proctorId,
    List<SelectedCoursesToTeachModel> courses,
    String className,
    String description,
    String institutionId,
  ) async {
    try {
      // get current info
      final Timestamp timestamp = Timestamp.now();

      // get the SubjectIds Only
      List<String> courseIds =
          courses.map((course) => course.subjectId).toList();

      // create a new class
      SubjectMatterModel newSubjectMatter = SubjectMatterModel(
        proctorId: proctorId,
        dateCreated: timestamp,
        courseId: courseIds,
        className: className,
        description: description,
      );

      DocumentReference newSubjectMatterRef = await institution
          .doc(institutionId)
          .collection("subject_matters")
          .add(
            newSubjectMatter.toMap(),
          );

      String subjectMatterId = newSubjectMatterRef.id;

      await institution
          .doc(institutionId)
          .collection("subject_matters")
          .doc(subjectMatterId)
          .update({'classId': subjectMatterId});

      var data = {
        "classId": subjectMatterId,
      };
      await institution
          .doc(institutionId)
          .collection("students")
          .doc(proctorId)
          .collection("subject_matters")
          .doc(subjectMatterId)
          .set(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
