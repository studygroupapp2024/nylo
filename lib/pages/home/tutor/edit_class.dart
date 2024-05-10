import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/dialogs/create_group.dart';
import 'package:nylo/components/information_snackbar.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/components/textfields/rounded_textfield_title.dart';
import 'package:nylo/pages/home/tutor/components/chips/tutor_courses_chip_with_button.dart';
import 'package:nylo/pages/home/tutor/search_course_to_teach.dart';
import 'package:nylo/structure/providers/course_provider.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class EditClass extends ConsumerWidget {
  final String className;
  final String classDescription;
  final String classId;

  EditClass({
    super.key,
    required this.className,
    required this.classDescription,
    required this.classId,
  });

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonColor = ref.watch(classButtonColorProvider);
    _nameController.text = className;
    _descriptionController.text = classDescription;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Update Class"),
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
                        "What courses do you want to teach?",
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
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: TutorCoursesChipWithButton(),
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
                    text: "Update",
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
                            await ref.read(subjectMatterProvider).updateClass(
                                  classId,
                                  ref.watch(
                                      selectedCoursesToTeachProvider), // subjectCode,
                                  _nameController.text,
                                  _descriptionController.text,
                                  ref.watch(setGlobalUniversityId),
                                );
                        if (success) {
                          _nameController.clear();
                          _descriptionController.clear();
                          Navigator.pop(context);

                          informationSnackBar(
                            context,
                            Icons.notifications,
                            "Class has been updated.",
                          );
                        } else {
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

                      ref.read(isLoadingProvider.notifier).state = false;
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
