import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/user_courses_container.dart';
import 'package:nylo/components/dialogs/alert_dialog.dart';
import 'package:nylo/pages/home/study_group/search_course.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class FindCourses extends ConsumerWidget {
  FindCourses({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Current Courses

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCourses = ref.watch(
      currentStudentCoursesInformationProvider(_auth.currentUser!.uid),
    );

    final completedCourses = ref.watch(
      completedStudentCoursesInformationProvider(_auth.currentUser!.uid),
    );

    final completedOrNot = ref.watch(isNotCompleted);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchCourse(),
                ),
              );
              ref.read(courseSearchQueryLengthProvider.notifier).state = 0;
              ref.read(courseSearchQueryProvider.notifier).state = "";
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(isNotCompleted.notifier).state = true;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                      left: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: completedOrNot
                          ? Theme.of(context).colorScheme.tertiaryContainer
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.subject_outlined,
                          color: completedOrNot
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "My Courses",
                          style: TextStyle(
                            color: completedOrNot
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(isNotCompleted.notifier).state = false;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: completedOrNot
                          ? null
                          : Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.done_all_rounded,
                          color: completedOrNot
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.background,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Completed",
                          style: TextStyle(
                            color: completedOrNot
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (completedOrNot)
            Column(
              children: [
                currentCourses.when(data: (currentCourses) {
                  return Wrap(
                    children: currentCourses.map<Widget>(
                      (currentCourse) {
                        var icon = (currentCourse.isCompleted == true)
                            ? Icon(
                                Icons.remove_circle_outline,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : Icon(
                                Icons.check_circle_outline,
                                color: Theme.of(context).colorScheme.primary,
                              );
                        return MyCoursesContainer(
                          courseTitle: currentCourse.courseTitle,
                          courseCode: currentCourse.courseCode,
                          icon: icon,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return ConfirmationDialog(
                                confirm: () async {
                                  ref.read(courseProvider).markCompleted(
                                        currentCourse.courseId,
                                        ref.watch(setGlobalUniversityId),
                                      );
                                },
                                content: "Have you completed this course?",
                                title: "Confirmation",
                                type: "Yes",
                              );
                            },
                          ),
                        );
                      },
                    ).toList(),
                  );
                }, error: (error, stackTrace) {
                  return Center(
                    child: Text('Error: $error'),
                  );
                }, loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ],
            ),
          if (!completedOrNot)
            Column(
              children: [
                completedCourses.when(
                  data: (completedCourse) {
                    return Wrap(
                      children: completedCourse.map<Widget>(
                        (completedCourses) {
                          var icon = (completedCourses.isCompleted == true)
                              ? Icon(
                                  Icons.remove_circle_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : Icon(
                                  Icons.check_circle_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                );
                          return MyCoursesContainer(
                            courseTitle: completedCourses.courseTitle,
                            courseCode: completedCourses.courseCode,
                            icon: icon,
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return ConfirmationDialog(
                                  confirm: () async {
                                    ref.read(courseProvider).deleteCourse(
                                          completedCourses.courseId,
                                          completedCourses.courseId,
                                          ref.watch(setGlobalUniversityId),
                                        );
                                  },
                                  content:
                                      "Do you really want to delete this course?",
                                  title: "Confirmation",
                                  type: "Yes",
                                );
                              },
                            ),
                          );
                        },
                      ).toList(),
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
              ],
            ),
        ],
      ),
    );
  }
}
