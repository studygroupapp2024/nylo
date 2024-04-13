import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nylo/structure/models/user_courses.dart';

class Courses {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // getting all the available courses

  // join a course
  Future<void> addCourse(
    String courseCode,
    String courseTitle,
    String courseId,
    String institutionId,
  ) async {
    // get current info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // create a new course
    StudentCoursesModel newCourse = StudentCoursesModel(
      courseId: courseId,
      courseCode: courseCode,
      courseTitle: courseTitle,
      isCompleted: false,
      completedDate: null,
      joinedDate: timestamp,
    );

    // add new course to user database
    await _firestore
        .collection('institution')
        .doc(institutionId)
        .collection('students')
        .doc(currentUserId)
        .collection("courses")
        .doc(courseId)
        .set(newCourse.toMap());

    // add the student Id to the list of who taken a specific course
    await FirebaseFirestore.instance
        .collection("institution")
        .doc(institutionId)
        .collection('subjects')
        .doc(courseId)
        .update({
      'studentId': FieldValue.arrayUnion(
        [currentUserId],
      )
    });
  }

  // get current user courses

  // mark course as completed
  Future<void> markCompleted(
    String documentId,
    String institutionId,
  ) async {
    final Timestamp timestamp = Timestamp.now();
    // add the student Id to the list of who taken a specific course
    await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection('students')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection("courses")
        .doc(documentId)
        .update(
      {
        'isCompleted': true,
        'completedDate': timestamp,
      },
    );
  }

  // Delete course from firestore
  Future<void> deleteCourse(
    String documentId,
    courseId,
    String institutionId,
  ) async {
    await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection('students')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection("courses")
        .doc(documentId)
        .delete();

    await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subjects")
        .doc(courseId)
        .update(
      {
        "studentId": FieldValue.arrayRemove(
          [_firebaseAuth.currentUser!.uid],
        ),
      },
    );
  }
}
