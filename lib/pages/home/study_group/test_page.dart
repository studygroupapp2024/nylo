import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';
import 'package:nylo/structure/services/university_service.dart';

class TestPage extends ConsumerWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TestPage({super.key});
  final UniversityInfo _info = UniversityInfo();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("INSTITUTION ID: ${ref.watch(setGlobalUniversityId)}");
    final userInfo =
        ref.watch(userInfoProvider(_firebaseAuth.currentUser!.uid));
    print("USER INFO: $userInfo");

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(_firebaseAuth.currentUser!.uid),
            RoundedButtonWithProgress(
              text: "TEST",
              onTap: () {
                final hehe =
                    _info.getUniversityId(_firebaseAuth.currentUser!.uid);

                print("HEHE: $hehe");
              },
              margin: const EdgeInsets.all(20),
              color: Colors.black,
              textcolor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
