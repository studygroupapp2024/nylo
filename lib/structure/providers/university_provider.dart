import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/university_model.dart';
import 'package:nylo/structure/services/university_service.dart';
import 'package:nylo/structure/services/user_service.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final UserInformation _userInformation = UserInformation();
// get all the university
final universityProvider = StreamProvider<List<UniversityModel>>((ref) {
  final getUniversities = _firestore.collection("institution").snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map(
              (snapshot) => UniversityModel.fromSnapshot(snapshot),
            )
            .toList(),
      );
  return getUniversities;
});

// get all the university domain
final universityDomainNamesProvider = StreamProvider<List<String>>((ref) {
  return _firestore
      .collection("institution")
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => doc.data()['emailIndicator'] as String)
          .toList())
      .asyncMap((courses) => courses);
});

final listOfDomains = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final domains = _firestore
      .collection("institution")
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => {
                'uniId': doc.id,
                'domains': doc.data()['domains'],
                'uniName': doc.data()['uniName'],
              })
          .toList()); // Added .toList() to convert the map result to a list
  return domains;
});
// final listOfDomains = StreamProvider<List<String>>((ref) {
//   return _firestore.collection("institution").snapshots().map((querySnapshot) =>
//       querySnapshot.docs
//           .map((doc) => (doc.data()['emailIndicator'] as List<dynamic>)).toList();

// });
// search university
final searchUniversityProvier =
    StreamProvider.autoDispose<List<UniversityModel>>((ref) {
  final searchQuery = ref.watch(uniSearchQueryProvider);

  final searchUniversities =
      _firestore.collection("institution").snapshots().map(
            (querySnapshot) => querySnapshot.docs
                .map((snapshot) => UniversityModel.fromSnapshot(snapshot))
                .where((university) => university.uniName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList(),
          );

  return searchUniversities;
});

final getUniversityId = FutureProvider.family<String, String>(
  (ref, userId) async {
    // Introducing a delay of 2 seconds
    await Future.delayed(const Duration(seconds: 4));
    final snapshot = await _firestore
        .collection('institution')
        .where('students', arrayContains: userId)
        .get();

    // Process the snapshot to extract the university ID
    // For example:
    if (snapshot.docs.isNotEmpty) {
      final uniId = snapshot.docs.first.data()['uniId'];
      // if (uniId!= null && uniId is String) {
      // final setUserData = await _userInformation.getUserInfo(userId, uniId);
      //   // Set the global university ID state and UserInfo

      // ref.read(currentUserName.notifier).state = setUserData['name'];
      // ref.read(currentUserNameFCMToken.notifier).state =
      //     setUserData['fcmtoken'];
      // ref.read(currentUserImageURL.notifier).state = setUserData['imageUrl'];
      // ref.read(currentUserEmail.notifier).state = setUserData['email'];
      // ref.read(currentUserUID.notifier).state = userId;
      ref.read(setGlobalUniversityId.notifier).state = uniId;

      return uniId;
    } else {
      throw Exception('University ID not found for the user');
    }
  },
);

final setGlobalUniversityId = StateProvider<String>((ref) => '');

// ============================= STATE PROVIDER =============================

// set the Institution Id
final institutionIdProvider = StateProvider<String?>((ref) => null);

final institutionIdProviderBasedOnUser = StateProvider<UniversityInfo>((ref) {
  return UniversityInfo();
});

final uniSearchQueryProvider = StateProvider<String>((ref) => '');
