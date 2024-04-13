// A [FirebaseAuthException] maybe thrown with the following error code:

// email-already-in-use:
// Thrown if there already exists an account with the given email address.
// invalid-email:
// Thrown if the email address is not valid.
// operation-not-allowed:
// Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.
// weak-password:
// Thrown if the password is not strong enough.

import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExceptionErrorExtension on FirebaseAuthException {
  String getErrorMessage() {
    switch (code) {
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.';
      case 'weak-password':
        return 'The password must be 6 characters long or more.';
      default:
        return 'Incorrect email or password. Please try again.';
    }
  }
}
