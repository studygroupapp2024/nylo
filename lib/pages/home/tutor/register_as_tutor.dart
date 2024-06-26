import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/dialogs/create_group.dart';
import 'package:nylo/components/information_snackbar.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/components/textfields/rounded_textfield_title.dart';
import 'package:nylo/pages/home/tutor/search_course_to_teach.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class RegisterAsTutorPage extends ConsumerWidget {
  RegisterAsTutorPage({
    super.key,
  });

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonColor = ref.watch(classButtonColorProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Register as Tutor"),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  RoundedTextFieldTitle(
                    title: "What will be the name of your class?",
                    hinttext: "Class",
                    controller: _nameController,
                    onChange: (val) {
                      ref.read(classChatNameProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      bottom: 10,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Manage the courses you want to teach.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  if (ref.watch(selectedCoursesToTeachProvider).isEmpty)
                    Center(
                      child: NoContent(
                          icon: 'assets/icons/study-student_svgrepo.com.svg',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchCourseToTeach(),
                              ),
                            );
                            ref
                                .read(selectedCoursesToTeachProvider.notifier)
                                .state = [];
                            ref.read(courseSearchQueryProvider.notifier).state =
                                "";
                            ref
                                .read(courseSearchQueryLengthProvider.notifier)
                                .state = 0;
                          },
                          description: "Select a course to teach",
                          buttonText: "Search Courses"),
                    ),
                  if (ref.watch(selectedCoursesToTeachProvider).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 8.0, // Adjust spacing as needed
                              runSpacing: 8.0, // Adjust run spacing as needed
                              children: ref
                                  .watch(selectedCoursesToTeachProvider)
                                  .map<Widget>(
                                (course) {
                                  return IntrinsicWidth(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                                  .read(
                                                      selectedCoursesToTeachProvider
                                                          .notifier)
                                                  .remove(courseToRemove);
                                            },
                                            icon: const Icon(
                                                Icons.remove_circle_outline),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IntrinsicWidth(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SearchCourseToTeach(),
                                    ),
                                  );
                                  ref
                                      .watch(courseSearchQueryProvider.notifier)
                                      .state = '';

                                  ref
                                      .watch(courseSearchQueryLengthProvider
                                          .notifier)
                                      .state = 0;
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.add_circle_outline),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("Add Course")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  RoundedTextFieldTitle(
                    title: "What will be the purpose of your class?",
                    controller: _descriptionController,
                    hinttext:
                        "Let other students know about the purpose of the class.",
                    onChange: (val) {
                      ref.read(classChatDescriptionProvider.notifier).state =
                          val;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RoundedButtonWithProgress(
                    text: "Register",
                    onTap: () async {
                      ref.read(isLoadingProvider.notifier).state = true;
                      if (_nameController.text.isEmpty ||
                          _descriptionController.text.isEmpty ||
                          ref.watch(selectedCoursesToTeachProvider).isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const CreateGroupChatDialog(
                              confirm: null,
                              content:
                                  "There was an error updating the class. Kindly try again.",
                              title: "Failed",
                              type: "Okay",
                            );
                          },
                        );
                        ref.read(isLoadingProvider.notifier).state = false;
                      } else {
                        final success =
                            await ref.read(subjectMatterProvider).teachCourse(
                                  _auth.currentUser!.uid,
                                  ref.watch(
                                      selectedCoursesToTeachProvider), // subjectCode,
                                  _nameController.text,
                                  _descriptionController.text,
                                  ref.watch(setGlobalUniversityId),
                                );

                        ref.read(isLoadingProvider.notifier).state = false;

                        if (success) {
                          _nameController.clear();
                          _descriptionController.clear();
                          if (context.mounted) {
                            Navigator.pop(context);
                            informationSnackBar(
                              context,
                              Icons.notifications,
                              "Class has been created.",
                            );
                          }
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const CreateGroupChatDialog(
                                  confirm: null,
                                  content:
                                      "There was an error creating the class. Kindly try again.",
                                  title: "Failed",
                                  type: "Okay",
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    color: buttonColor
                        ? const Color(0xff9494ff)
                        : const Color(0xff939cc4),
                    textcolor: Theme.of(context).colorScheme.background,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
