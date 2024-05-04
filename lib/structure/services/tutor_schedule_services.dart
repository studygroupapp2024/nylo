import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/structure/models/schedule_model.dart';
import 'package:nylo/structure/services/user_service.dart';

class TutorScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessage _firebaseMessage = FirebaseMessage();
  final UserInformation _users = UserInformation();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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

  Future<bool> bookSchedule(
    String scheduleId,
    String tuteeId,
    String institutionId,
    String classId,
    String? tutorId,
  ) async {
    await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subject_matters")
        .doc(classId)
        .collection("schedules")
        .doc(scheduleId)
        .update(
      {
        'tuteeId': tuteeId,
        'status': "booked",
      },
    );

    // current user Info
    final userInfo = await _users.getUserInfo(
      _firebaseAuth.currentUser!.uid,
      institutionId,
    );

    final userInfodata = userInfo.data();

    final fcmtoken = userInfodata!['fcmtoken'];
    final userName = userInfodata['name'];

    _firebaseMessage.sendPushMessage(
      recipientToken: fcmtoken,
      title: "Appointment Notification",
      body: "$userName has book a tutorial session with you.",
      route: 'appointment',
      tutorId: tutorId,
      classId: classId,
    );
    return true;
  }

  Future<bool> acceptBooking(
    String scheduleId,
    String tuteeId,
    String institutionId,
    String classId,
  ) async {
    await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subject_matters")
        .doc(classId)
        .collection("schedules")
        .doc(scheduleId)
        .update(
      {
        'tuteeId': tuteeId,
        'status': "occupied",
      },
    );

    // tuteee Info
    final userInfo = await _users.getUserInfo(
      tuteeId,
      institutionId,
    );

    final userInfodata = userInfo.data();

    final fcmtoken = userInfodata!['fcmtoken'];

    // current user Info
    final currentUserInfo = await _users.getUserInfo(
      _firebaseAuth.currentUser!.uid,
      institutionId,
    );

    final currentUserInfodata = currentUserInfo.data();

    final currentUserName = currentUserInfodata!['name'];

    _firebaseMessage.sendPushMessage(
      recipientToken: fcmtoken,
      title: "Appointment Notification",
      body:
          "Your request for tutorial session with $currentUserName has been accepted.",
      route: 'appointment',
    );

    return true;
  }

  Future<bool> rejectBooking(
    String scheduleId,
    String tuteeId,
    String institutionId,
    String classId,
  ) async {
    await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("subject_matters")
        .doc(classId)
        .collection("schedules")
        .doc(scheduleId)
        .update(
      {
        'tuteeId': null,
        'status': "available",
      },
    );

    // tuteee Info
    final userInfo = await _users.getUserInfo(
      tuteeId,
      institutionId,
    );

    final userInfodata = userInfo.data();

    final fcmtoken = userInfodata!['fcmtoken'];

    // current user Info
    final currentUserInfo = await _users.getUserInfo(
      _firebaseAuth.currentUser!.uid,
      institutionId,
    );

    final currentUserInfodata = currentUserInfo.data();

    final currentUserName = currentUserInfodata!['name'];

    _firebaseMessage.sendPushMessage(
      recipientToken: fcmtoken,
      title: "Appointment Notification",
      body:
          "Your request for tutorial session with $currentUserName has been rejected.",
      route: 'appointment',
    );
    return true;
  }
}
