import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/services/course_services.dart';

class SearchCourseToTeach extends ConsumerWidget {
  SearchCourseToTeach({super.key});
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Courses courses = Courses();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Courses",
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  int characterCount = value.length;
                  ref
                      .read(courseSearchQueryLengthProvider.notifier)
                      .update((state) => characterCount);
                  ref
                      .read(courseSearchQueryProvider.notifier)
                      .update((state) => value);
                },
                obscureText: false,
                controller: _controller,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8.0, // Adjust spacing as needed
                  runSpacing: 8.0, // Adjust run spacing as needed
                  children:
                      ref.watch(selectedCoursesToTeachProvider).map<Widget>(
                    (course) {
                      return IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(course.subjectCode),
                              const SizedBox(
                                width: 2,
                              ),
                              IconButton(
                                onPressed: () {
                                  final courseToRemove = course;
                                  ref
                                      .read(selectedCoursesToTeachProvider
                                          .notifier)
                                      .remove(courseToRemove);
                                  print(ref
                                      .watch(selectedCoursesToTeachProvider));
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            if (ref.watch(courseSearchQueryLengthProvider) < 3)
              const Expanded(
                child: Center(
                  child: Text(
                    "Search courses by subject code and title",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (ref.watch(courseSearchQueryLengthProvider) >= 3)
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final unenrolledCourses = ref.watch(
                      unenrolledCoursesProvider(_auth.currentUser!.uid),
                    );
                    return unenrolledCourses.when(data: (courses) {
                      if (courses.isEmpty) {
                        return const NoContent(
                            icon: 'assets/icons/study-student_svgrepo.com.svg',
                            onPressed: null,
                            description:
                                "There are no courses available at the moment.",
                            buttonText: '');
                      } else {
                        return ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return GestureDetector(
                              onTap: () async {
                                String subjectId = course['subjectId'];
                                String subjectTitle = course['subject_title'];
                                String subjectCode = course['subject_code'];
                                // ref.read(courseProvider).addCourse(
                                //       course['subject_code'],
                                //       course['subject_title'],
                                //       course['subjectId'],
                                //       ref.watch(setGlobalUniversityId),
                                //     );

                                final selectedCourse =
                                    ref.watch(selectedCoursesToTeachProvider);

                                for (final course in selectedCourse) {
                                  if (course.subjectId.contains(subjectId)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.notifications,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiaryContainer,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "$subjectCode is already added.",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiaryContainer,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                }
                                ref
                                    .read(
                                        selectedCoursesToTeachProvider.notifier)
                                    .add(
                                      SelectedCoursesToTeachModel(
                                        subjectId: subjectId,
                                        subjectTitle: subjectTitle,
                                        subjectCode: subjectCode,
                                      ),
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.notifications,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "$subjectCode has been added.",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(course['subject_title']),
                                subtitle: Text(course['subject_code']),
                              ),
                            );
                          },
                        );
                      }
                    }, error: (error, stackTrace) {
                      return Center(
                        child: Text('Error: $error'),
                      );
                    }, loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
