import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';

class SubjectMatter {
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
      List<String> subjectCode =
          courses.map((course) => course.subjectCode).toList();
      List<String> subjectTitle =
          courses.map((course) => course.subjectTitle).toList();
      // create a new class
      String concatenatedSubjectCode = subjectCode.join(', ');
      String concatenatedSubjectTitle = subjectTitle.join(', ');
      SubjectMatterModel newSubjectMatter = SubjectMatterModel(
        proctorId: proctorId,
        dateCreated: timestamp,
        courseId: courseIds,
        className: className,
        description: description,
        courseCodes: concatenatedSubjectCode,
        courseTitles: concatenatedSubjectTitle,
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

  Future<void> removeClass(
    String classId,
    String institutionId,
    String userId,
  ) async {
    // delete the class
    await institution
        .doc(institutionId)
        .collection("subject_matters")
        .doc(classId)
        .delete();

    // remove the class from the user
    await institution
        .doc(institutionId)
        .collection("students")
        .doc(userId)
        .collection("subject_matters")
        .doc(classId)
        .delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSubjectInfo(
    String subjectId,
    String institutionId,
  ) async {
    return await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection('subjects')
        .doc(subjectId)
        .get();
  }

  Future<bool> updateClass(
    String classId,
    List<SelectedCoursesToTeachModel> courses,
    String className,
    String description,
    String institutionId,
  ) async {
    List<String> courseIds = courses.map((course) => course.subjectId).toList();

    List<String> subjectCode =
        courses.map((course) => course.subjectCode).toList();
    List<String> subjectTitle =
        courses.map((course) => course.subjectTitle).toList();
    String concatenatedSubjectCode = subjectCode.join(', ');
    String concatenatedSubjectTitle = subjectTitle.join(', ');
    await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subject_matters")
        .doc(classId)
        .update({
      "courseId": courseIds,
      "className": className,
      "description": description,
      "courseCodes": concatenatedSubjectCode,
      "courseTitles": concatenatedSubjectTitle,
    });
    return true;
  }
}
