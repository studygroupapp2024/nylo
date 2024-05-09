import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/user_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/user_service.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Define a model for the user data
final userInfoProvider =
    StreamProvider.family<UserModel, String>((ref, userId) {
  final institutionId = ref.watch(setGlobalUniversityId);
  final document = _firestore
      .collection("institution")
      .doc(institutionId)
      .collection("students")
      .doc(userId);
  return document.snapshots().map(
        (snapshot) => UserModel.fromSnapshot(snapshot),
      );
});

final userInfoService = StateProvider.autoDispose<UserInformation>((ref) {
  return UserInformation();
});

final nameProvider = StateProvider<String>((ref) => '');

final editProfilePathProvider = StateProvider<File?>((ref) => null);

final editProfilePathNameProvider = StateProvider<String>((ref) => '');

final editProfileNameProvider = StateProvider<String>((ref) => '');

// ================== CURRENT USER INFO PROVIDER ======================

final currentUserName = StateProvider<String>((ref) => '');

final currentUserNameFCMToken = StateProvider<String>((ref) => '');

final currentUserImageURL = StateProvider<String>((ref) => '');

final currentUserEmail = StateProvider<String>((ref) => '');

final currentUserUID = StateProvider<String>((ref) => '');
