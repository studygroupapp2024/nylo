import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/register_as_tutor.dart';
import 'package:nylo/structure/services/course_services.dart';

class RegisterAsTutor extends ConsumerWidget {
  RegisterAsTutor({super.key});
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Courses courses = Courses();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Subject Matter",
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterAsTutorPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ]),
      ),
    );
  }
}
