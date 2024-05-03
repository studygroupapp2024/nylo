import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/components/chips/tutor_courses_chip.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';

class TutorCoursesChipWithName extends ConsumerWidget {
  final AsyncValue<SubjectMatterModel> asyncTutorCourses;
  const TutorCoursesChipWithName({
    super.key,
    required this.asyncTutorCourses,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        return asyncTutorCourses.when(
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.className,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 5,
                ),
                TutorCoursesChip(groupChats: data),
              ],
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
        );
      },
    );
  }
}
