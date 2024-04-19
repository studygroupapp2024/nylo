import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/dialogs/create_group.dart';
import 'package:nylo/components/image_placeholder/image_placeholder.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/components/textfields/rounded_textfield_title.dart';
import 'package:nylo/pages/home/study_group/my_courses.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class CreateStudyGroup extends ConsumerWidget {
  CreateStudyGroup({super.key});

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
          title: const Text("Create Study Group"),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 125,
                    width: 125,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: [
                              'jpg',
                              'png',
                            ],
                          );

                          if (result == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No image has been selected."),
                              ),
                            );
                            return;
                          }
                          final path = result.files.single.path;
                          final filename = result.files.single.name;

                          ref.read(editUploadImagePathProvider.notifier).state =
                              File(path.toString());

                          print("path: ${path.toString()}");

                          ref
                              .read(editUploadImagePathNameProvider.notifier)
                              .state = path.toString();

                          ref.read(editUploadImageNameProvider.notifier).state =
                              filename;
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              child: ImagePlaceholder(
                                title: ref.watch(selectedCourseProvider) != ''
                                    ? ref
                                        .watch(selectedCourseProvider)
                                        .toString()
                                    : "Create",
                                subtitle: "Study Group",
                                titleFontSize: 8,
                                subtitleFontSize: 6,
                              ),
                            ),
                            if (ref.watch(editUploadImagePathProvider) != null)
                              CircleAvatar(
                                backgroundImage: FileImage(
                                    ref.watch(editUploadImagePathProvider)!),
                                radius: 55,
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      radius: 13,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      radius: 12,
                                      child: Icon(
                                        Icons.add,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RoundedTextFieldTitle(
                    title: "What is the name of the study group?",
                    hinttext: "Name",
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: currentUserCourse.when(data: (currentCourses) {
                          if (currentCourses.isEmpty) {
                            return Center(
                              child: NoContent(
                                  icon:
                                      'assets/icons/study-student_svgrepo.com.svg',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FindCourses(),
                                      ),
                                    );
                                  },
                                  description: "You have no enrolled courses.",
                                  buttonText: "Enroll in a course"),
                            );
                          } else {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                children: currentCourses.map((completed) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: FilterChip(
                                      label: Text(completed.courseCode),
                                      selected: selectedCourse ==
                                          completed.courseCode,
                                      onSelected: (bool selected) {
                                        ref
                                            .read(
                                                selectedCourseProvider.notifier)
                                            .state = completed.courseCode;
                                        ref
                                            .read(selectedcourseIdProvider
                                                .notifier)
                                            .state = completed.courseId;
                                        ref
                                            .read(selectedcourseTitleProvider
                                                .notifier)
                                            .state = completed.courseTitle;
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
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
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RoundedTextFieldTitle(
                    title: "What is the study group all about?",
                    controller: _descriptionController,
                    hinttext:
                        "Let other students know about the purpose of the study group.",
                    onChange: (val) {
                      ref.read(chatDescriptionProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RoundedButtonWithProgress(
                    text: "Create Study Group",
                    onTap: () async {
                      ref.read(isLoadingProvider.notifier).state = true;
                      final success =
                          await ref.read(groupChatProvider).addStudyGroup(
                                _nameController.text,
                                _descriptionController.text,
                                selectedCourse.toString(),
                                courseId.toString(),
                                courseTitle.toString(),
                                ref.watch(setGlobalUniversityId),
                                ref
                                    .watch(editUploadImagePathNameProvider)
                                    .toString(),
                                ref.watch(editUploadImageNameProvider),
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
