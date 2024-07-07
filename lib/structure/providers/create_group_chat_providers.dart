import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef CourseCode = String;
typedef ChatName = String;
typedef ChatNameDescription = String;
typedef CourseId = String;
typedef CourseTitle = String;

final selectedCourseProvider = StateProvider<CourseCode>((ref) => '');
final chatNameProvider = StateProvider<ChatName>((ref) => '');
final chatDescriptionProvider = StateProvider<ChatNameDescription>((ref) => '');
final selectedcourseIdProvider = StateProvider<CourseId?>((ref) => null);

final selectedcourseTitleProvider = StateProvider<CourseTitle?>((ref) => null);
final buttonColorProvider = StateProvider<bool>((ref) {
  final selectedCourse = ref.watch(selectedCourseProvider);
  final chatName = ref.watch(chatNameProvider);
  final chatDescription = ref.watch(chatDescriptionProvider);
//selectedCourse!.isNotEmpty &&
  return (chatName.isNotEmpty &&
      chatDescription.isNotEmpty &&
      selectedCourse.isNotEmpty);
});

final editUploadImagePathProvider = StateProvider<File?>((ref) => null);

final editUploadImagePathNameProvider = StateProvider<String>((ref) => '');

final editUploadImageNameProvider = StateProvider<String>((ref) => '');

final isLoadingProvider = StateProvider<bool>((ref) => false);
