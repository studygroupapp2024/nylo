import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/components/chips/schedule_chip.dart';
import 'package:nylo/structure/models/schedule_model.dart';

class ScheduleChipWithName extends ConsumerWidget {
  final AsyncValue<List<TutorScheduleModel>> schedules;
  const ScheduleChipWithName({
    super.key,
    required this.schedules,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        return schedules.when(data: (data) {
          return data.isEmpty
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 0.3,
                    ),
                    const Text(
                      "Schedule",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ScheduleChip(schedules: data),
                  ],
                );
        }, error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        }, loading: () {
          return Container();
        });
      },
    );
  }
}
