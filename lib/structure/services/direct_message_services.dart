import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nylo/structure/models/direct_message_model.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';
import 'package:nylo/structure/services/chat_services.dart';
import 'package:nylo/structure/services/subject_matter_services.dart';
import 'package:nylo/structure/services/user_service.dart';

class DirectMessage {
  final institution = FirebaseFirestore.instance.collection("institution");

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserInformation _users = UserInformation();
  final ChatService _chatService = ChatService();

  // create a Direct Message
  Future<Map<String, dynamic>> addDirectMessage(
    String institutionId,
    String proctorId,
    String subjectMatterId,
    List<SelectedCoursesToTeachModel> courses,
    String className,
  ) async {
    //get student data
    final userInfo =
        await _users.getUserInfo(_auth.currentUser!.uid, institutionId);

    final userInfodata = userInfo.data();

    final userName = userInfodata!['name'];
    final userImage = userInfodata['imageUrl'];
    //get proctor data
    final proctorInfo = await _users.getUserInfo(proctorId, institutionId);
    final proctorInfoData = proctorInfo.data();

    final proctorName = proctorInfoData!['name'];
    final proctorImage = proctorInfoData['imageUrl'];
    try {
      final Timestamp timestamp = Timestamp.now();

      DirectMessageModel newDirectMessage = DirectMessageModel(
        timestamp: timestamp,
        lastMessage: '',
        lastMessageSender: '',
        lastMessageTimeSent: null,
        lastMessageType: '',
        membersId: [proctorId, _auth.currentUser!.uid],
        proctorId: proctorId,
        classId: subjectMatterId,
        tuteeId: _auth.currentUser!.uid,
        lastMessageId: null,
        className: className,
      );

      DocumentReference newDirectMessageRef = await institution
          .doc(institutionId)
          .collection("direct_messages")
          .add(
            newDirectMessage.toMap(),
          );

      String directMessageId = newDirectMessageRef.id;

      await institution
          .doc(institutionId)
          .collection("direct_messages")
          .doc(directMessageId)
          .update({'chatId': directMessageId});

      // ADD MEMBERS
      Member tutee = Member(
        isAdmin: false,
        receiveNotification: true,
        id: _auth.currentUser!.uid,
        imageUrl: userImage,
        name: userName,
      );

      Member proctor = Member(
        isAdmin: true,
        receiveNotification: true,
        id: proctorId,
        imageUrl: proctorImage,
        name: proctorName,
      );

      final List<Member> members = [tutee, proctor];

      List<Member> membersMap = members.map((members) => members).toList();

      for (var member in membersMap) {
        final ChatMembers membersModel = ChatMembers(
          isAdmin: member.isAdmin,
          receiveNotification: member.receiveNotification,
          imageUrl: member.imageUrl,
          name: member.name,
        );

        final MembersMap addMember = MembersMap(
          members: {
            member.id: membersModel,
          },
        );

        // Subjects to add
        await institution
            .doc(institutionId)
            .collection("direct_messages")
            .doc(directMessageId)
            .set(addMember.toMap(), SetOptions(merge: true));
      }

      // Add the group chat to the user's subject matter
      var data = {
        "classId": subjectMatterId,
      };

      await institution
          .doc(institutionId)
          .collection("students")
          .doc(_auth.currentUser!.uid)
          .collection("subject_matters")
          .doc(subjectMatterId)
          .set(data);

      // Add the class to the proctor's direct messages
      var setDirectMessageId = {
        "directMessageId": directMessageId,
      };
      await institution
          .doc(institutionId)
          .collection("students")
          .doc(proctorId)
          .collection("direct_messages")
          .doc(directMessageId)
          .set(setDirectMessageId);

      // Add the class to the student's direct messages
      await institution
          .doc(institutionId)
          .collection("students")
          .doc(_auth.currentUser!.uid)
          .collection("direct_messages")
          .doc(directMessageId)
          .set(setDirectMessageId);

      // Send a message to the direct message
      var type = "announcement";
      var message = "$userName has started a conversation with you.";
      await _chatService.sendAnnouncementMessage(
        directMessageId,
        message,
        type,
        "",
        institutionId,
        false,
      );

      //ADD SUBJECTS
      List<SelectedCoursesToTeachModel> subjectsMap =
          courses.map((course) => course).toList();

      for (var subject in subjectsMap) {
        final Subject subjectModel = Subject(
          subjectCode: subject.subjectCode,
          subjectTitle: subject.subjectTitle,
        );

        final SubjectMap addSubject = SubjectMap(
          subjects: {
            subject.subjectId: subjectModel,
          },
        );

        // Subjects to add
        await institution
            .doc(institutionId)
            .collection("direct_messages")
            .doc(directMessageId)
            .set(addSubject.toMap(), SetOptions(merge: true));
      }

      Map<String, dynamic> createMap() {
        Map<String, dynamic> myMap = {
          'directMessageId': directMessageId,
          'title': proctorName,
          'creator': proctorId,
          'dateCreated': timestamp.toString(),
          'membersId': [proctorId, _auth.currentUser!.uid],
          'classId': subjectMatterId,
          'isSuccess': true,
          // Add more key-value pairs as needed
        };

        return myMap;
      }

      return createMap();
    } catch (e) {
      Map<String, dynamic> createMap() {
        Map<String, dynamic> myMap = {
          'directMessageId': '',
          'title': '',
          'creator': '',
          'dateCreated': '',
          'membersId': [],
          'classId': '',
          'isSuccess': false,
          // Add more key-value pairs as needed
        };

        return myMap;
      }

      return createMap();
    }
  }
}
