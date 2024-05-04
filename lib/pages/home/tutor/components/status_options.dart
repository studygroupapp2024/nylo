import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/providers/course_provider.dart';

class StatusOption extends ConsumerWidget {
  const StatusOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedOrNot = ref.watch(isNotCompleted);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Option(ref, completedOrNot, context, "Occupied"),
          const SizedBox(
            width: 5,
          ),
          Option(ref, completedOrNot, context, "Booked"),
          const SizedBox(
            width: 5,
          ),
          Option(ref, completedOrNot, context, "Available"),
        ],
      ),
    );
  }

  Expanded Option(
      WidgetRef ref, bool completedOrNot, BuildContext context, String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(isNotCompleted.notifier).state = true;
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(
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
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    );
  }
}
