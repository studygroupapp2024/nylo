import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nylo/structure/models/schedule_model.dart';

class TutorScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Schedule
  Future<bool> addSchedule(
    DateTime date,
    String startTime,
    String endTime,
    String tutorId,
    String classId,
    String institutionId,
  ) async {
    // Fill in the Model
    TutorScheduleModel tutorSchedule = TutorScheduleModel(
      date: date,
      startTime: startTime,
      endTime: endTime,
      status: "available",
      classId: classId,
    );

    // Add a reference to the schedule
    DocumentReference newTutorSchedule = await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subject_matters")
        .doc(classId)
        .collection("schedules")
        .add(
          tutorSchedule.toMap(),
        );

    // get the Schedule ID
    String scheduleId = newTutorSchedule.id;

    // update the Schedule ID
    _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subject_matters")
        .doc(classId)
        .collection("schedules")
        .doc(scheduleId)
        .update({
      'scheduleId': scheduleId,
    });

    return true;
  }
}
