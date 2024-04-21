import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/study_group/create_study_group.dart';
import 'package:nylo/pages/home/study_group/my_courses.dart';
import 'package:nylo/pages/home/study_group/my_study_groups.dart';
import 'package:nylo/pages/home/study_group/search_study_group.dart';
import 'package:nylo/pages/home/tutor/find_tutor.dart';
import 'package:nylo/pages/home/tutor/my_tutor.dart';
import 'package:nylo/pages/home/tutor/my_tutor_classes.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color backgroundColor;
  VoidCallback? onTap;
  String caption;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.backgroundColor,
    required this.onTap,
    required this.caption,
  });

  static List<CategoryModel> tutorCategories(
      BuildContext context, WidgetRef ref) {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        caption: "Become a tutor",
        name: "Register",
        iconPath: 'assets/icons/learning-teacher_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterAsTutor(),
            ),
          );
          ref.read(searchQueryLengthProvider.notifier).update((state) => 0);
          ref.read(searchQueryProvider.notifier).update((state) => '');
        },
      ),
    );

    categories.add(
      CategoryModel(
        caption: "Find a tutor",
        name: "Seach",
        iconPath: 'assets/icons/search_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FindTutor(),
            ),
          );
          ref
              .read(findTutorSearchQueryLengthProvider.notifier)
              .update((state) => 0);
          ref.read(findTutorSearchQueryProvider.notifier).update((state) => '');
        },
      ),
    );

    categories.add(
      CategoryModel(
        caption: "Guides in learning",
        name: "Tutors",
        iconPath: 'assets/icons/presentation-teacher_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorClassses(),
            ),
          );
          ref.read(searchQueryLengthProvider.notifier).update((state) => 0);
          ref.read(searchQueryProvider.notifier).update((state) => '');
        },
      ),
    );
    return categories;
  }

  static List<CategoryModel> studyGroupCategories(
      BuildContext context, WidgetRef ref) {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: "Courses",
        iconPath: 'assets/icons/study-student_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        caption: "Check your courses",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FindCourses(),
            ),
          );
        },
      ),
    );

    categories.add(
      CategoryModel(
        name: "Study Groups",
        iconPath: 'assets/icons/users-group_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        caption: "Communicate with your circle",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: "/MyChats"),
              builder: (context) => FindPage(),
            ),
          );
        },
      ),
    );

    categories.add(
      CategoryModel(
        name: "Create",
        caption: "Lead the study group",
        iconPath:
            'assets/icons/book-shelf-books-education-learning-school-study_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateStudyGroup(),
            ),
          );

          ref.read(selectedCourseProvider.notifier).update((state) => '');
          ref.read(selectedcourseIdProvider.notifier).update((state) => '');
          ref.read(selectedcourseTitleProvider.notifier).update((state) => '');

          ref
              .read(editUploadImagePathNameProvider.notifier)
              .update((state) => '');
          ref
              .read(editUploadImagePathProvider.notifier)
              .update((state) => null);
          ref.read(editUploadImageNameProvider.notifier).update((state) => '');
        },
      ),
    );

    categories.add(
      CategoryModel(
        caption: "Connect with other groups",
        name: "Find",
        iconPath: 'assets/icons/search-phone_svgrepo.com.svg',
        backgroundColor: const Color.fromARGB(255, 222, 159, 172),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FindStudyGroup(),
            ),
          );
          ref.read(searchQueryLengthProvider.notifier).update((state) => 0);
          ref.read(searchQueryProvider.notifier).update((state) => '');
        },
      ),
    );

    return categories;
  }
}
