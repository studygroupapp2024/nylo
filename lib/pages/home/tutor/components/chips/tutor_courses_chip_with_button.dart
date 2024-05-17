import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';

class TutorCoursesChipWithButton extends ConsumerWidget {
  const TutorCoursesChipWithButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8.0, // Adjust spacing as needed
      runSpacing: 8.0, // Adjust run spacing as needed
      children: ref.watch(selectedCoursesToTeachProvider).map<Widget>(
        (course) {
          return IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(course.subjectCode),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      final courseToRemove = course;

                      ref
                          .read(removeCoursesProvider.notifier)
                          .state
                          .add(courseToRemove.subjectId);

                      ref
                          .read(selectedCoursesToTeachProvider.notifier)
                          .remove(courseToRemove);
                    },
                    child: const Icon(Icons.remove_circle_outline),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
