import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/my_home.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class InitializeData extends ConsumerWidget {
  InitializeData({super.key});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue hehe =
        ref.watch(getUniversityId(_firebaseAuth.currentUser!.uid));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hehe.when(
              data: (data) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Switch screens only when the data is available
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                });
                return Container();
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
