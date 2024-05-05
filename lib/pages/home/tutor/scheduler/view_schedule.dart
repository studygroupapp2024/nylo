import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/components/containers/schedule_container.dart';
import 'package:nylo/pages/home/tutor/components/status_options.dart';
import 'package:nylo/pages/home/tutor/functions/date_formatter.dart';
import 'package:nylo/pages/home/tutor/scheduler/add_schedule.dart';
import 'package:nylo/structure/models/schedule_model.dart';
import 'package:nylo/structure/providers/tutor_schedules_provider.dart';

class ViewSchedule extends ConsumerWidget {
  final String classId;
  final String tutorId;
  const ViewSchedule({
    super.key,
    required this.classId,
    required this.tutorId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSchedule(
                    classId: classId,
                    tutorId: tutorId,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.schedule),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const StatusOption(),
          Expanded(child: Consumer(
            builder: (context, ref, child) {
              final AsyncValue<List<TutorScheduleModel>> getSchedule;

              if (ref.watch(selectedAvailable)) {
                getSchedule = ref.watch(filteredSchedulesProvider(
                    (classId: classId, status: 'available')));
              } else if (ref.watch(selectedBooked)) {
                getSchedule = ref.watch(filteredSchedulesProvider(
                    (classId: classId, status: 'booked')));
              } else {
                getSchedule = ref.watch(filteredSchedulesProvider(
                  (classId: classId, status: 'occupied'),
                ));
              }
              return getSchedule.when(
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
                        tuteeId: sched.tuteeId,
                        isChat: false,
                        classId: classId,
                        scheduleId: sched.scheduleId,
                        tuteeName: sched.tuteeName,
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
              );
            },
          ))
        ],
      ),
    );
  }
}
