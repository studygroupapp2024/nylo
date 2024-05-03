import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/schedule_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/tutor_schedule_services.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final dateControllerProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);
final startTimeControllerProvider = StateProvider<TimeOfDay>(
  (ref) => TimeOfDay.now(),
);
final endTimeControllerProvider = StateProvider<TimeOfDay>(
  (ref) => TimeOfDay.now(),
);

final tutorSchedulesProvider = StateProvider<TutorScheduleService>((ref) {
  return TutorScheduleService();
});

final schedulesProvider =
    StreamProvider.family<List<TutorScheduleModel>, String>((ref, classId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final schedules = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("subject_matters")
      .doc(classId)
      .collection("schedules")
      // .where('status', isNotEqualTo: 'occupied')
      .orderBy("status", descending: true)
      .orderBy("date", descending: true)
      .orderBy("__name__", descending: true)
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (snapshot) => TutorScheduleModel.fromSnapshot(snapshot),
            )
            .toList(),
      );
  return schedules;
});

final selectedschedulesProvider =
    StreamProvider.family<List<TutorScheduleModel>, String>((ref, classId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final schedules = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("subject_matters")
      .doc(classId)
      .collection("schedules")
      .where("status", isEqualTo: "available")
      .orderBy("status", descending: true)
      .orderBy("date", descending: true)
      .orderBy("__name__", descending: true)
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (snapshot) => TutorScheduleModel.fromSnapshot(snapshot),
            )
            .toList(),
      );
  return schedules;
});
