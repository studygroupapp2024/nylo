import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/dialogs/create_group.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/components/textfields/rounded_textfield_title.dart';
import 'package:nylo/pages/home/search_course_to_teach.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/subject_matter.dart';
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
    final currentUserCourse = ref.watch(
      currentStudentCoursesInformationProvider(_auth.currentUser!.uid),
    );
    final selectedCourse = ref.watch(selectedCourseProvider);
    final courseId = ref.watch(selectedcourseIdProvider);
    final courseTitle = ref.watch(selectedcourseTitleProvider);
    final buttonColor = ref.watch(buttonColorProvider);

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
                      ref.read(chatNameProvider.notifier).state = val;
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
                        "What course is the study group for?",
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
                          },
                          description: "Select a course to teach",
                          buttonText: "Search Courses"),
                    ),
                  if (ref.watch(selectedCoursesToTeachProvider).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8.0, // Adjust spacing as needed
                          runSpacing: 8.0, // Adjust run spacing as needed
                          children: ref
                              .watch(selectedCoursesToTeachProvider)
                              .map((course) {
                            return IntrinsicWidth(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Text(course.subjectCode),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    const IconButton(
                                      onPressed: null,
                                      icon: Icon(Icons.remove_circle_outline),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
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
                      ref.read(chatDescriptionProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RoundedButtonWithProgress(
                    text: "Register",
                    onTap: () async {
                      ref.read(isLoadingProvider.notifier).state = true;

                      final success =
                          await ref.read(subjectMatterProvider).teachCourse(
                                _auth.currentUser!.uid,
                                "test", // subjectId,
                                "test", // subjectCode,
                                "test", // subjectTitle,

                                _nameController.text,
                                _descriptionController.text,
                                ref.watch(setGlobalUniversityId),
                              );

                      ref.read(isLoadingProvider.notifier).state = false;

                      if (success) {
                        _nameController.clear();
                        _descriptionController.clear();
                        ref.read(selectedCourseProvider.notifier).state = '';
                        ref.read(selectedcourseIdProvider.notifier).state = '';
                        ref.read(selectedcourseTitleProvider.notifier).state =
                            '';

                        ref.read(editUploadImagePathProvider.notifier).state =
                            null;

                        ref
                            .read(editUploadImagePathNameProvider.notifier)
                            .state = '';

                        ref.read(editUploadImageNameProvider.notifier).state =
                            '';

                        showDialog(
                          context: context,
                          builder: (context) {
                            return const CreateGroupChatDialog(
                              confirm: null,
                              content: "The group chat has been created",
                              title: "Success",
                              type: "Okay",
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const CreateGroupChatDialog(
                              confirm: null,
                              content:
                                  "There was an error creating the study group. Kindly try again.",
                              title: "Failed",
                              type: "Okay",
                            );
                          },
                        );
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
