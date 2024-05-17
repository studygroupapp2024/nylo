import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/university_model.dart';
import 'package:nylo/structure/services/university_service.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// get all the university
final universityProvider =
    StreamProvider.autoDispose<List<UniversityModel>>((ref) {
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
final universityDomainNamesProvider =
    StreamProvider.autoDispose<List<String>>((ref) {
  return _firestore
      .collection("institution")
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => doc.data()['emailIndicator'] as String)
          .toList())
      .asyncMap((courses) => courses);
});

final listOfDomains =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
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

final getUniversityIdProvider =
    FutureProvider.family.autoDispose<String, String>(
  (ref, userId) async {
    // Introducing a delay of 2 seconds
    // await Future.delayed(const Duration(seconds: 4));
    final snapshot = await _firestore
        .collection('institution')
        .where('students', arrayContains: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final uniId = snapshot.docs.first.data()['uniId'];

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
