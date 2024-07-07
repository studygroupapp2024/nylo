import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/user_courses_container.dart';
import 'package:nylo/components/dialogs/alert_dialog.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/components/skeletons/my_courses_loading.dart';
import 'package:nylo/pages/home/study_group/search_course.dart';
import 'package:nylo/structure/models/user_courses.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class FindCourses extends ConsumerWidget {
  FindCourses({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Current Courses

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<StudentCoursesModel>>? courses;

    final completedOrNot = ref.watch(isNotCompleted);

    if (completedOrNot) {
      courses = ref.watch(
          currentStudentCoursesInformationProvider(_auth.currentUser!.uid));
    } else {
      courses = ref.watch(
        completedStudentCoursesInformationProvider(_auth.currentUser!.uid),
      );
    }
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
          ListViewOption(ref, completedOrNot, context),
          // if (completedOrNot)
          Column(
            children: [
              courses!.when(
                data: (courses) {
                  if (courses.isEmpty) {
                    return Center(
                      child: NoContent(
                        icon: 'assets/icons/study-student_svgrepo.com.svg',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchCourse(),
                            ),
                          );
                        },
                        description: !completedOrNot
                            ? "No completed courses"
                            : "Find your courses",
                        buttonText: "Enroll to a course",
                      ),
                    );
                  } else {
                    return Wrap(
                      children: courses.map<Widget>(
                        (courseData) {
                          var icon = (courseData.isCompleted == true)
                              ? Icon(
                                  Icons.remove_circle_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : Icon(
                                  Icons.check_circle_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                );
                          return MyCoursesContainer(
                            courseTitle: courseData.courseTitle,
                            courseCode: courseData.courseCode,
                            icon: icon,
                            onTap: () {
                              completedOrNot
                                  ? showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ConfirmationDialog(
                                          confirm: () async {
                                            ref
                                                .read(courseProvider)
                                                .markCompleted(
                                                  courseData.courseId,
                                                  ref.watch(
                                                      setGlobalUniversityId),
                                                );
                                          },
                                          content:
                                              "Have you completed this course?",
                                          title: "Confirmation",
                                          type: "Yes",
                                        );
                                      },
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ConfirmationDialog(
                                          confirm: () async {
                                            ref
                                                .read(courseProvider)
                                                .deleteCourse(
                                                  courseData.courseId,
                                                  courseData.courseId,
                                                  ref.watch(
                                                      setGlobalUniversityId),
                                                );
                                          },
                                          content:
                                              "Do you really want to delete this course?",
                                          title: "Confirmation",
                                          type: "Yes",
                                        );
                                      },
                                    );
                            },
                          );
                        },
                      ).toList(),
                    );
                  }
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Text('Error: $error'),
                  );
                },
                loading: () {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 500,
                      child: MyCoursesLoading(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row ListViewOption(WidgetRef ref, bool completedOrNot, BuildContext context) {
    return Row(
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
    );
  }
}
