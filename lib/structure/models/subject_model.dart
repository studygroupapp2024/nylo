// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  String subject_title;
  String subject_code;
  List<dynamic> studentId;

  SubjectModel({
    required this.subject_title,
    required this.subject_code,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subject_title': subject_title,
      'subject_code': subject_code,
      'studentId': studentId,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      subject_title: map['subject_title'] as String,
      subject_code: map['subject_code'] as String,
      studentId: List<dynamic>.from(
        (map['studentId'] as List<dynamic>),
      ),
    );
  }

  factory SubjectModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return SubjectModel(
      subject_title: doc['subject_title'],
      subject_code: doc['subject_code'],
      studentId: doc['studentId'],
    );
  }
}
