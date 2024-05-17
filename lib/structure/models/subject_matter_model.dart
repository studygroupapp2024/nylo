// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nylo/structure/services/subject_matter_services.dart';

class SubjectMatterModel {
  final String proctorId;
  final Timestamp dateCreated;
  Map<String, Subject>? subjects;
  final String className;
  final String description;
  final String? classId;
  final String courseCodes;
  final String courseTitles;

  SubjectMatterModel({
    required this.proctorId,
    required this.dateCreated,
    this.subjects,
    required this.className,
    required this.description,
    this.classId,
    required this.courseCodes,
    required this.courseTitles,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'proctorId': proctorId,
      'dateCreated': dateCreated,
      'subjects':
          subjects?.map((key, value) => MapEntry(key, value.toMap())) ?? {},
      'className': className,
      'description': description,
      'classId': classId,
      'courseCodes': courseCodes,
      'courseTitles': courseTitles,
    };
  }

  factory SubjectMatterModel.fromMap(Map<String, dynamic> map) {
    final subjectsMap = <String, Subject>{};

    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        subjectsMap[key] = Subject.fromMap(value);
      }
    });

    return SubjectMatterModel(
      proctorId: map['proctorId'] as String,
      dateCreated:
          Timestamp.fromDate(DateTime.parse(map['timestamp'] as String)),
      subjects: subjectsMap,
      className: map['className'] as String,
      description: map['description'] as String,
      classId: map['classId'] as String,
      courseCodes: map['courseCodes'] as String,
      courseTitles: map['courseTitles'] as String,
    );
  }

  factory SubjectMatterModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final subjectsMap = doc.data()?['subjects'] as Map<String, dynamic>? ?? {};
    return SubjectMatterModel(
      proctorId: doc['proctorId'],
      dateCreated: doc['dateCreated'],
      subjects: subjectsMap.map((key, value) =>
          MapEntry(key, Subject.fromMap(value as Map<String, dynamic>))),
      className: doc['className'],
      description: doc['description'],
      classId: doc['classId'],
      courseCodes: doc['courseCodes'],
      courseTitles: doc['courseTitles'],
    );
  }
}

class SubjectMap {
  Map<String, Subject>? subjects;

  SubjectMap({this.subjects});

  Map<String, dynamic> toMap() {
    return {
      'subjects': subjects!.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}
