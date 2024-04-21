// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityModel {
  final String uniName;
  final String abbreviation;
  final String logo;
  final String color;

  final String uniId;
  final List<dynamic> students;
  final List<dynamic> domains;

  UniversityModel({
    required this.uniName,
    required this.abbreviation,
    required this.logo,
    required this.color,
    required this.uniId,
    required this.students,
    required this.domains,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uniName': uniName,
      'abbreviation': abbreviation,
      'logo': logo,
      'color': color,
      'students': students,
      'domains': domains,
    };
  }

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    return UniversityModel(
      uniName: map['uniName'] as String,
      abbreviation: map['abbreviation'] as String,
      logo: map['logo'] as String,
      color: map['color'] as String,
      uniId: map['uniId'] as String,
      students: List<dynamic>.from((map['students'] as List<dynamic>)),
      domains: List<dynamic>.from((map['domains'] as List<dynamic>)),
    );
  }

  factory UniversityModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return UniversityModel(
      uniName: doc['uniName'],
      abbreviation: doc['abbreviation'],
      logo: doc['logo'],
      color: doc['color'],
      uniId: doc['uniId'],
      students: doc['students'],
      domains: doc['domains'],
    );
  }
}
