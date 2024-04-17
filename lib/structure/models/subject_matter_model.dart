// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectMatterModel {
  final String proctorId;
  final Timestamp dateCreated;
  final List<dynamic> courseId;

  final String className;
  final String description;
  final String? classId;

  SubjectMatterModel({
    required this.proctorId,
    required this.dateCreated,
    required this.courseId,
    required this.className,
    required this.description,
    this.classId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'proctorId': proctorId,
      'dateCreated': dateCreated,
      'courseId': courseId,
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
      courseId: List<dynamic>.from((map['membersId'] as List<dynamic>)),
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
      className: doc['className'],
      description: doc['description'],
      classId: doc['classId'],
    );
  }
}
