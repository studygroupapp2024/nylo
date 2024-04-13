import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityInfo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> getUniversityId(String domain) async {
    final snapshot = await _firebaseFirestore
        .collection('institution')
        .where('emailIndicator', isEqualTo: domain)
        .get();

    return snapshot.docs.first.data()['uniId'];
  }

  Future<String> getUniversityName(String domain) async {
    final snapshot = await _firebaseFirestore
        .collection('institution')
        .where('emailIndicator', isEqualTo: domain)
        .get();

    return snapshot.docs.first.data()['uniName'];
  }
}
