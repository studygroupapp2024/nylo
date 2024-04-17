import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/register_as_tutor.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/services/course_services.dart';

class RegisterAsTutor extends ConsumerWidget {
  RegisterAsTutor({super.key});
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Courses courses = Courses();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSubjectMatter =
        ref.watch(userSubjectMatterProvider(_auth.currentUser!.uid));

    print("userSubjectMatter: $userSubjectMatter");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Subject Matter",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterAsTutorPage(),
                ),
              );
              ref.read(selectedCoursesToTeachProvider.notifier).clear();
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: userSubjectMatter.when(
        data: (subjectMatter) {
          return ListView.builder(
            itemCount: subjectMatter.length,
            itemBuilder: (context, index) {
              final classes = subjectMatter[index];

              return Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(classes.className),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(classes.description),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 10,
                        children: classes.courseId
                            .map(
                              (e) => Consumer(
                                builder: (context, ref, child) {
                                  final course = ref.watch(getSubjectInfo(e));

                                  return course.when(
                                    data: (data) {
                                      return Chip(
                                        label: Text(
                                          data.subject_code,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    },
                                    error: (error, stackTrace) {
                                      return Center(
                                        child: Text('Error: $error'),
                                      );
                                    },
                                    loading: () {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
