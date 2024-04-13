import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The scopes required by this application.
// #docregion Initialize
const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);

class GoogleSignin extends StatefulWidget {
  const GoogleSignin({super.key});

  @override
  State<GoogleSignin> createState() => _GoogleSignin();
}

class _GoogleSignin extends State<GoogleSignin> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
