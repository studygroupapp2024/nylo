// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectMatterModel {
  final String proctorId;
  final Timestamp dateCreated;
  final String courseId;
  final String courseCode;
  final String courseTitle;
  final String className;
  final String description;
  final String? classId;

  SubjectMatterModel({
    required this.proctorId,
    required this.dateCreated,
    required this.courseId,
    required this.courseCode,
    required this.courseTitle,
    required this.className,
    required this.description,
    this.classId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'proctorId': proctorId,
      'dateCreated': dateCreated,
      'courseId': courseId,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'className': className,
      'description': description,
      'classId': classId,
    };
  }

  factory SubjectMatterModel.fromMap(Map<String, dynamic> map) {
    return SubjectMatterModel(
      proctorId: map['proctorId'] as String,
      dateCreated:
          Timestamp.fromDate(DateTime.parse(map['timestamp'] as String)),
      courseId: map['courseId'] as String,
      courseCode: map['courseCode'] as String,
      courseTitle: map['courseTitle'] as String,
      className: map['className'] as String,
      description: map['description'] as String,
      classId: map['classId'] as String,
    );
  }

  factory SubjectMatterModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return SubjectMatterModel(
      proctorId: doc['proctorId'],
      dateCreated: doc['dateCreated'],
      courseId: doc['courseId'],
      courseCode: doc['courseCode'],
      courseTitle: doc['courseTitle'],
      className: doc['className'],
      description: doc['description'],
      classId: doc['classId'],
    );
  }
}
