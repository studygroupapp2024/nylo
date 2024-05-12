import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserInformation {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
    String userId,
    String institutionId,
  ) async {
    return await _firestore
        .collection("institution")
        .doc(institutionId)
        .collection('students')
        .doc(userId)
        .get();
  }

  Future<String?> changeProfilePicture(
    String filePath,
    String filename,
    String userId,
    String institutionId,
    String name,
  ) async {
    try {
      if (filename.isNotEmpty) {
        File file = File(filePath);
        await _firebaseStorage.ref('profileImages/$filename').putFile(file);
        String downloadUrl = await _firebaseStorage
            .ref('profileImages/$filename')
            .getDownloadURL();

        await _firestore
            .collection("institution")
            .doc(institutionId)
            .collection("students")
            .doc(userId)
            .update({
          "imageUrl": downloadUrl,
          "name": name,
        });
        return downloadUrl;
      } else {
        await _firestore
            .collection("institution")
            .doc(institutionId)
            .collection("students")
            .doc(userId)
            .update({
          "name": name,
        });
      }
    } on FirebaseException catch (e) {}
    return null;
  }
}
