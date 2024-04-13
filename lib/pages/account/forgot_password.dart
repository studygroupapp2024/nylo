import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nylo/components/buttons/rounded_button.dart';
import 'package:nylo/components/dialogs/create_group.dart';
import 'package:nylo/components/textfields/rounded_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void passwordReset(BuildContext context) async {
    try {
      if (_emailController.text.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Password Reset Email Sent'),
            content:
                const Text('Please check your email to reset your password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const CreateGroupChatDialog(
                confirm: null,
                content: "Kindly enter your email to proceed.",
                title: "Failed",
                type: "Okay");
          },
        );
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return const CreateGroupChatDialog(
                confirm: null,
                content: "There was an error. Please try again.",
                title: "Failed",
                type: "Okay");
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Forgot your password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Text(
                "Don't worry enter your registered email address to received password reset link",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            RoundedTextField(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Remember your password?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12)),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Login now",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            RoundedButton(
              text: "Send",
              onTap: () => passwordReset(context),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              color: Theme.of(context).colorScheme.tertiaryContainer,
              textcolor: Theme.of(context).colorScheme.background,
            ),
          ],
        ),
      ),
    );
  }
}
