import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  final String creatorId;
  final String creatorName;
  final String studyGroupTitle;
  final String studyGroupDescription;
  final String studyGroupCourseName;
  final String studyGroupCourseId;
  final Timestamp timestamp;
  final List<dynamic> members;
  final List<dynamic> membersId;
  final List<dynamic> membersRequest;
  final List<dynamic> membersRequestId;

  GroupChat({
    required this.creatorId,
    required this.creatorName,
    required this.studyGroupTitle,
    required this.studyGroupDescription,
    required this.studyGroupCourseName,
    required this.studyGroupCourseId,
    required this.timestamp,
    required this.members,
    required this.membersId,
    required this.membersRequest,
    required this.membersRequestId,
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'creatorId': creatorId,
      'creatorName': creatorName,
      'studyGroupTitle': studyGroupTitle,
      'studyGroupDescription': studyGroupDescription,
      'studyGroupCourseName': studyGroupCourseName,
      'studyGroupCourseId': studyGroupCourseId,
      'createdAt': timestamp,
      'members': members,
      'membersId': membersId,
      'membersRequest': membersRequest,
      'membersRequestId': membersRequestId,
    };
  }
}
