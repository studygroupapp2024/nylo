// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeOfDayMapper {
  static TimeOfDay fromMap(Map<String, dynamic> map) {
    final hour = map['hour'] as int;
    final minute = map['minute'] as int;
    return TimeOfDay(hour: hour, minute: minute);
  }
}

class TutorScheduleModel {
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? tuteeId;
  final String status;
  final String classId;
  final String? scheduleId;
  final String? tuteeName;

  TutorScheduleModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    this.tuteeId,
    required this.status,
    required this.classId,
    this.scheduleId,
    this.tuteeName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'startTime': startTime,
      'endTime': endTime,
      'tuteeId': tuteeId,
      'status': status,
      'classId': classId,
      'scheduleId': scheduleId,
      'tuteeName': tuteeName
    };
  }

  factory TutorScheduleModel.fromMap(Map<String, dynamic> map) {
    return TutorScheduleModel(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      tuteeId: map['tuteeId'] as String,
      status: map['status'] as String,
      classId: map['classId'] as String,
      scheduleId: map['scheduleId'] as String,
      tuteeName: map['tuteeName'] as String,
    );
  }

  factory TutorScheduleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return TutorScheduleModel(
      date: DateTime.fromMillisecondsSinceEpoch(doc['date'] as int),
      startTime: doc['startTime'],
      endTime: doc['endTime'],
      tuteeId: doc['tuteeId'],
      status: doc['status'],
      classId: doc['classId'],
      scheduleId: doc['scheduleId'],
      tuteeName: doc['tuteeName'],
    );
  }
}
