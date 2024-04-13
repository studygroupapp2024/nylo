import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nylo/structure/auth/login_or_register.dart';

import '../../pages/account/verify_email.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            return const LoginOrRegister();
          }
          //user not logged in
        },
      ),
    );
  }
}
