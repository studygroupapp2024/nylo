// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentCoursesModel {
  final String courseId;
  final String courseCode;
  final String courseTitle;
  final bool isCompleted;
  final Timestamp? completedDate;
  final Timestamp joinedDate;

  StudentCoursesModel({
    required this.courseId,
    required this.courseCode,
    required this.courseTitle,
    required this.isCompleted,
    required this.completedDate,
    required this.joinedDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseId': courseId,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'isCompleted': isCompleted,
      'completedDate': completedDate,
      'joinedDate': joinedDate,
    };
  }

  factory StudentCoursesModel.fromMap(Map<String, dynamic> map) {
    return StudentCoursesModel(
      courseId: map['courseId'] as String,
      courseCode: map['courseCode'] as String,
      courseTitle: map['courseTitle'] as String,
      isCompleted: map['isCompleted'] as bool,
      completedDate: map['completedDate'] != null
          ? Timestamp.fromDate(DateTime.parse(map['completedDate'] as String))
          : null,
      joinedDate:
          Timestamp.fromDate(DateTime.parse(map['joinedDate'] as String)),
    );
  }
  factory StudentCoursesModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return StudentCoursesModel(
      courseId: doc['courseId'],
      courseCode: doc['courseCode'],
      courseTitle: doc['courseTitle'],
      isCompleted: doc['isCompleted'],
      completedDate: doc['completedDate'],
      joinedDate: doc['joinedDate'],
    );
  }
}

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'courseId': courseId,
  //     'courseCode': courseCode,
  //     'courseTitle': courseTitle,
  //     'isCompleted': isCompleted,
  //     'completedData': completedData,
  //     'joinedDate': timestamp,
  //   };
  // }

  // factory StudentCoursesModel.fromSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> doc) {
  //   return StudentCoursesModel(
  //     courseId: doc['courseId'],
  //     courseCode: doc['courseCode'],
  //     courseTitle: doc['courseTitle'],
  //     isCompleted: doc['isCompleted'],
  //     completedData: doc['completedData'],
  //     timestamp: doc['joinedDate'],
  //   );
  // }