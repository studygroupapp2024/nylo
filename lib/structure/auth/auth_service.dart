import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/information_snackbar.dart';
import 'package:nylo/error/firebaseauth_exception_error_extension.dart';
import 'package:nylo/error/login_response.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/structure/models/user_model.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class AuthService {
  // instance of Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessage _firebaseMessage = FirebaseMessage();

  // signin
// signin
  Future<LoginResponse> signInWithEmailPassword(
      BuildContext context,
      String email,
      String password,
      List<Map<String, dynamic>> idAndUni) async {
    try {
      final userDomain = email.split('@').last;

      String? uni;
      for (final entry in idAndUni) {
        if (entry['domains'].contains("@$userDomain")) {
          uni = entry['uniId'];
          break;
        }
      }

      final fcmtoken = await _firebaseMessage.getFCMToken();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection('institution')
          .doc(uni)
          .collection("students")
          .doc(userCredential.user!.uid)
          .set(
        {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'fcmtoken': fcmtoken,
        },
        SetOptions(merge: true),
      );

      return LoginResponse(isSuccess: true, message: "Success");
    } on FirebaseAuthException catch (e) {
      // If FirebaseAuthException occurs, throw a general Exception with a custom error message
      return LoginResponse(
        isSuccess: false,
        message: e.getErrorMessage(),
      );
    }
  }

  // signup
  Future<LoginResponse> signUpWithEmailPassword(
    BuildContext context,
    String email,
    String password,
    String firstName,
    String lastName,
    String university,
    String universityId,
    String emailDomain,
    List<String> domains,
    WidgetRef ref,
  ) async {
    try {
      if (!domains.contains(emailDomain)) {
        // Email does not match the required domain
        await signOut(ref); // Sign out the user
        if (context.mounted) {
          informationSnackBar(
            context,
            Icons.info_outline,
            'There is no domain match',
          );
        }
        // Return null to indicate failed sign-in attempt
        return LoginResponse(
            isSuccess: false, message: "There is no domain match");
      }
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email + emailDomain,
        password: password,
      );

      final fcmtoken = await _firebaseMessage.getFCMToken();
      UserModel newUserData = UserModel(
        uid: userCredential.user!.uid,
        name: "$firstName $lastName",
        email: email + emailDomain,
        fcmtoken: fcmtoken.toString(),
        imageUrl: userCredential.user!.photoURL.toString(),
        university: university,
        universityId: universityId,
      );

      _firestore
          .collection("institution")
          .doc(universityId)
          .collection('students')
          .doc(userCredential.user!.uid)
          .set(newUserData.toMap(), SetOptions(merge: true));

      await _firestore.collection('institution').doc(universityId).update({
        'students': FieldValue.arrayUnion([userCredential.user!.uid]),
      });
      return LoginResponse(isSuccess: true, message: null);
    } on FirebaseAuthException catch (e) {
      return LoginResponse(isSuccess: false, message: e.getErrorMessage());
    }
  }

  // signout
  Future<void> signOut(WidgetRef ref) async {
    // Cleaning all listeners to prevent permission denied error when signing out
    ref.invalidate(userHasStudyGroupRequest);
    ref.invalidate(userInfoProvider);
    ref.invalidate(userChatIdsProvider);
    ref.invalidate(currentStudentCoursesInformationProvider);
    ref.invalidate(completedStudentCoursesInformationProvider);
    ref.invalidate(userInfoProvider);
    ref.invalidate(singleGroupChatInformationProvider);
    ref.invalidate(tutorDirectMessages);
    ref.invalidate(tuteeDirectMessages);
    ref.invalidate(selectedClassInformationProvider);
    ref.invalidate(userSubjectMatterProvider);
    ref.invalidate(unenrolledCoursesProvider);
    ref.invalidate(multipleStudentCoursesInformationProvider);
    ref.invalidate(selectedGroupChatInformationProvider);
    ref.invalidate(courseIdProvider);
    ref.invalidate(directMessageMemberInfoProvider);

    await _auth.signOut();
    // sign out from Google
    await GoogleSignIn().signOut();
  }

  // reset password
  Future passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message.toString());
    }
  }

// signin with Google account
  Future<UserCredential?> signInWithGoogle(
    BuildContext context,
    List<Map<String, dynamic>> idAndUni,
    WidgetRef ref,
  ) async {
    try {
      // Begin interactive signin process
      final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

      if (guser != null) {
        // Obtain auth details from request
        final GoogleSignInAuthentication gAuth = await guser.authentication;

        // Create a new credential for user
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        // Sign in with Google
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Get the user's email domain
        final userId = userCredential.user!.uid;
        final userEmail = userCredential.user!.email!;
        final userDomain = userEmail.split('@').last;

        // Check if the user's domain is in the list of allowed domains
        String? uni;
        String? uniName;
        for (final entry in idAndUni) {
          if (entry['domains'].contains("@$userDomain")) {
            uni = entry['uniId'];
            uniName = entry['uniName'];
            break;
          }
        }

        if (uni == null || uniName == null) {
          await signOut(ref); // Sign out the user
          if (context.mounted) {
            informationSnackBar(
              context,
              Icons.info_outline,
              'Email domain is not allowed.',
            );
          }
          return null;
        }

        final fcmtoken = await _firebaseMessage.getFCMToken();

        // Add user to Firestore
        await _firestore.collection('institution').doc(uni).update({
          'students': FieldValue.arrayUnion([userId]),
        });

        UserModel newUserData = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          fcmtoken: fcmtoken!,
          universityId: uni,
          university: uniName,
          name: userCredential.user!.displayName!,
          imageUrl: userCredential.user!.photoURL.toString(),
        );

        final DocumentReference docRef = _firestore
            .collection('institution')
            .doc(uni)
            .collection("students")
            .doc(userCredential.user!.uid);

        final DocumentSnapshot docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          // Document exists, update only necessary fields
          await docRef.update({
            'fcmtoken': fcmtoken,
          });
        } else {
          // Document does not exist, create it
          await docRef.set(newUserData.toMap());
        }

        return userCredential;
      }
    } catch (e) {
      await signOut(ref); // Sign out the user
      if (context.mounted) {
        informationSnackBar(
          context,
          Icons.info_outline,
          'Email domain is not allowed.',
        );
      }
      return null;
    }
    return null;
  }
}
