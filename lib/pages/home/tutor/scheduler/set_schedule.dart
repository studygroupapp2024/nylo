import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/components/schedule_container.dart';
import 'package:nylo/pages/home/tutor/functions/date_formatter.dart';
import 'package:nylo/structure/providers/tutor_schedules_provider.dart';

class SetSchedule extends ConsumerWidget {
  final String classId;
  final String tutorId;
  const SetSchedule({
    super.key,
    required this.classId,
    required this.tutorId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getSchedule = ref.watch(schedulesProvider(classId));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: getSchedule.when(
              data: (schedules) {
                return ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final sched = schedules[index];

                    return ScheduleContainer(
                      date: formatDate(sched.date),
                      startTime: sched.startTime,
                      endTime: sched.endTime,
                      status: sched.status,
                      tuteeName: sched.tuteeId,
                      isChat: true,
                    );
                  },
                );
              },
              error: (error, stackTrace) => Text(
                error.toString(),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
