import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/dialogs/alert_dialog.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/pages/home/tutor/components/chips/tutor_courses_chip.dart';
import 'package:nylo/pages/home/tutor/edit_class.dart';
import 'package:nylo/pages/home/tutor/register_as_tutor.dart';
import 'package:nylo/pages/home/tutor/scheduler/view_schedule.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/course_services.dart';

class RegisterAsTutor extends ConsumerWidget {
  RegisterAsTutor({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Courses courses = Courses();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSubjectMatter =
        ref.watch(userSubjectMatterProvider(_auth.currentUser!.uid));

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
              ref.watch(courseSearchQueryProvider.notifier).state = '';

              ref.watch(courseSearchQueryLengthProvider.notifier).state = 0;
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: userSubjectMatter.when(
        data: (subjectMatter) {
          if (subjectMatter.isNotEmpty) {
            return ListView.builder(
              itemCount: subjectMatter.length,
              itemBuilder: (context, index) {
                final classes = subjectMatter[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewSchedule(
                          classId: classes.classId!,
                          tutorId: classes.proctorId,
                        ),
                      ),
                    );
                  },
                  child: IntrinsicHeight(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        classes.className,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(classes.description),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TutorCoursesChip(groupChats: classes),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Delete Class
                                    InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ConfirmationDialog(
                                            confirm: () async {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
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
                                                        "The class has been removed.",
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .tertiaryContainer,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiary,
                                                  elevation: 4,
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                ),
                                              );

                                              await ref
                                                  .read(subjectMatterProvider)
                                                  .removeClass(
                                                    classes.classId!,
                                                    ref.watch(
                                                        setGlobalUniversityId),
                                                    _auth.currentUser!.uid,
                                                  );
                                            },
                                            content:
                                                "Are you sure you want to remove this class?",
                                            title: "Confirmation",
                                            type: "Yes",
                                          );
                                        },
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(Icons
                                            .remove_circle_outline_outlined),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () async {
                                        ref
                                            .read(selectedCoursesToTeachProvider
                                                .notifier)
                                            .clear();
                                        for (final item in classes.courseId) {
                                          final subjectInfo = await ref
                                              .read(subjectMatterProvider)
                                              .getSubjectInfo(
                                                  item,
                                                  ref.watch(
                                                      setGlobalUniversityId));

                                          final data = subjectInfo.data();

                                          ref
                                              .read(
                                                  selectedCoursesToTeachProvider
                                                      .notifier)
                                              .add(
                                                SelectedCoursesToTeachModel(
                                                  subjectId: item,
                                                  subjectTitle:
                                                      data!['subject_title'],
                                                  subjectCode:
                                                      data['subject_code'],
                                                ),
                                              );
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditClass(
                                              className: classes.className,
                                              classDescription:
                                                  classes.description,
                                              classId: classes.classId!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Icon(Icons.edit_note_rounded)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: NoContent(
                  icon: 'assets/icons/study-student_svgrepo.com.svg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterAsTutorPage(),
                      ),
                    );
                    ref.read(selectedCoursesToTeachProvider.notifier).state =
                        [];
                    ref.read(courseSearchQueryProvider.notifier).state = "";
                    ref.read(courseSearchQueryLengthProvider.notifier).state =
                        0;
                  },
                  description:
                      "Currently, you do not have any classes to teach.",
                  buttonText: "Create Class"),
            );
          }
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
