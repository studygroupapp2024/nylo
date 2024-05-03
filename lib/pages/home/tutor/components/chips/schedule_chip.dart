import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/functions/date_formatter.dart';
import 'package:nylo/structure/models/schedule_model.dart';

class ScheduleChip extends ConsumerWidget {
  final List<TutorScheduleModel> schedules;
  const ScheduleChip({
    super.key,
    required this.schedules,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 10,
      children: schedules.map<Widget>(
        (TutorScheduleModel data) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              child: Text(
                "${formatDateShort(data.date)} - ${data.startTime} - ${data.endTime}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

String formatSchedule() {
  return '10:00 AM - 11:00 AM';
}
