import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/chat_members_model.dart';
import 'package:nylo/structure/models/group_chat_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/group_chat_service.dart';
import 'package:nylo/structure/services/member_request_service.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

// ============================ STREAM PROVIDERS =============================

final singleGroupChatInformationProvider =
    StreamProvider.family<GroupChatModel, String>((ref, chatId) async* {
  await Future.delayed(const Duration(seconds: 10));
  final institutionId = ref.watch(setGlobalUniversityId);
  final document = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("study_groups")
      .doc(chatId);
  yield* document.snapshots().map(
        GroupChatModel.fromSnapshot,
      );
});

final singleMemberGroupChatInformationProvider =
    StreamProvider.family<ChatMembersModel, String>((ref, chatId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final document = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("study_groups")
      .doc(chatId)
      .collection("members")
      .doc(_auth.currentUser!.uid);
  return document.snapshots().map(
        ChatMembersModel.fromSnapshot,
      );
});

// collect to all the document
final multipleGroupChatInformationProvider =
    StreamProvider<List<GroupChatModel>>((ref) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final getStudyGroups = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("study_groups")
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (snapshot) => GroupChatModel.fromSnapshot(snapshot),
            )
            .toList(),
      );
  return getStudyGroups;
});

final groupChatMembersProvider =
    StreamProvider.family<List<ChatMembersModel>, String>(
  (ref, chatId) {
    final institutionId = ref.watch(setGlobalUniversityId);
    final getMembers = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("study_groups")
        .doc(chatId)
        .collection("members")
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (members) => ChatMembersModel.fromSnapshot(members),
              )
              .toList(),
        );

    return getMembers;
  },
);

final courseIdProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  return _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("students")
      .doc(userId)
      .collection("courses")
      .where('isCompleted', isEqualTo: false)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => doc.data()['courseId'] as String)
          .toList());
});

final selectedGroupChatInformationProvider = StreamProvider.family
    .autoDispose<List<GroupChatModel>, String>((ref, userId) {
  final searchQuery = ref.watch(searchQueryProvider);
  final coursesTaken = ref.watch(courseIdProvider(userId)).value;
  final institutionId = ref.watch(setGlobalUniversityId);

  final getStudyGroups = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("study_groups")
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map((snapshot) => GroupChatModel.fromSnapshot(snapshot))
            .where((group) =>
                !group.membersId.contains(userId) &&
                coursesTaken!.contains(group.studyGroupCourseId) &&
                (group.studyGroupTitle
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    group.studyGroupCourseName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    searchQuery.isEmpty))
            .toList(),
      );

  return getStudyGroups;
});
// get User Study Groups
final userChatIdsProvider = StreamProvider.family<List<GroupChatModel>, String>(
  (ref, userId) {
    try {
      final institutionId = ref.watch(setGlobalUniversityId);
      final userStudyGroups = _firestore
          .collection("institution")
          .doc(institutionId)
          .collection("study_groups")
          .orderBy(
            'lastMessageTimeSent',
            descending: true,
          )
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (snapshot) => GroupChatModel.fromSnapshot(snapshot),
                )
                .where((group) => group.membersId.contains(userId))
                .toList(),
          );
      return userStudyGroups;
    } catch (e) {
      if (e is FirebaseException && e.code == 'permission-denied') {
        print('Permission denied: ${e.message}');
        return Stream.value([]);
        // Handle the permission denied error
      } else {
        print('Error: ${e.toString()}');
        return Stream.value([]);
        // Handle other errors
      }
    }
  },
);

final userLastChatProvider =
    StreamProvider.family<List<GroupChatModel>, String>(
  (ref, userId) {
    final userStudyGroups = _firestore
        .collection("study_groups")
        .orderBy(
          'lastMessageTimeSent',
          descending: true,
        )
        .where('members', arrayContains: userId)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (snapshot) => GroupChatModel.fromSnapshot(snapshot),
              )
              .toList(),
        );
    return userStudyGroups;
  },
);

final userHasStudyGroupRequest =
    StreamProvider.family.autoDispose<bool, String>(
  (ref, userId) {
    final institutionId = ref.watch(setGlobalUniversityId);
    final decision = _firestore
        .collection("institution")
        .doc(institutionId)
        .collection("study_groups")
        .where('creatorId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map(
              (snapshot) => GroupChatModel.fromSnapshot(snapshot),
            )
            .any((group) => group.membersRequestId.isNotEmpty));
    return decision;
  },
);

// ============================ STATE PROVIDERS =============================

final groupChatMemberRequestProvider =
    StateProvider.autoDispose<MemberRequest>((ref) {
  return MemberRequest();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchQueryLengthProvider = StateProvider<int>((ref) => 0);

final groupChatProvider = StateProvider.autoDispose<GroupChat>((ref) {
  return GroupChat();
});
