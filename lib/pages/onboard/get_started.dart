import 'package:flutter/material.dart';
import 'package:nylo/components/buttons/rounded_button.dart';
import 'package:nylo/structure/auth/login_or_register.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  void login() {
    print("CLICKED");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Study Buddy",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 40),
                  ),
                  Text(
                    "Connect with study partners and tutors easily.",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RoundedButton(
              text: "Get Started",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginOrRegister()),
                );
              },
              margin: const EdgeInsets.symmetric(horizontal: 25),
              color: Theme.of(context).colorScheme.inversePrimary,
              textcolor: Theme.of(context).colorScheme.background,
            ),
          ),
        ],
      ),
    );
  }
}
