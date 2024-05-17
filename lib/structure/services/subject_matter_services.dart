// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';

class Subject {
  String subjectTitle;
  String subjectCode;

  Subject({
    required this.subjectTitle,
    required this.subjectCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subjectTitle': subjectTitle,
      'subjectCode': subjectCode,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subjectTitle: map['subjectTitle'] as String,
      subjectCode: map['subjectCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source) as Map<String, dynamic>);
}

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
      print("COURSES: $courses");

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

      // UPDATING SUBJECTS

      List<SelectedCoursesToTeachModel> subjectsMap =
          courses.map((course) => course).toList();

      for (var subject in subjectsMap) {
        print(subject.subjectCode);

        final Subject subjectModel = Subject(
          subjectCode: subject.subjectCode,
          subjectTitle: subject.subjectTitle,
        );

        final SubjectMap addSubject = SubjectMap(
          subjects: {
            subject.subjectId: subjectModel,
          },
        );

        // Adding a subject
        await institution
            .doc(institutionId)
            .collection("subject_matters")
            .doc(subjectMatterId)
            .set(addSubject.toMap(), SetOptions(merge: true));
      }
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
    RemoveCourses removeCourses,
  ) async {
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
      "className": className,
      "description": description,
      "courseCodes": concatenatedSubjectCode,
      "courseTitles": concatenatedSubjectTitle,
    });

    List<SelectedCoursesToTeachModel> subjectsMap =
        courses.map((course) => course).toList();

    for (var subject in subjectsMap) {
      final Subject subjectModel = Subject(
        subjectCode: subject.subjectCode,
        subjectTitle: subject.subjectTitle,
      );

      final SubjectMap addSubject = SubjectMap(
        subjects: {
          subject.subjectId: subjectModel,
        },
      );

      // Subjects to add
      await institution
          .doc(institutionId)
          .collection("subject_matters")
          .doc(classId)
          .set(addSubject.toMap(), SetOptions(merge: true));
    }

    // Subjects to remove
    for (var subjectId in removeCourses) {
      await institution
          .doc(institutionId)
          .collection("subject_matters")
          .doc(classId)
          .update({
        'subjects.$subjectId': FieldValue.delete(),
      });
    }

    return true;
  }
}
