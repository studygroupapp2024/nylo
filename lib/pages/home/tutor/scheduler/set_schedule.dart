import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/pages/home/tutor/components/containers/schedule_container.dart';
import 'package:nylo/pages/home/tutor/functions/date_formatter.dart';
import 'package:nylo/structure/providers/tutor_schedules_provider.dart';

class SetSchedule extends ConsumerWidget {
  final String classId;
  final String tutorId;
  SetSchedule({
    super.key,
    required this.classId,
    required this.tutorId,
  });

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getSchedule = ref.watch(selectedschedulesProvider(classId));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                return getSchedule.when(
                  data: (schedules) {
                    if (schedules.isEmpty) {
                      return const NoContent(
                          icon:
                              'assets/icons/book-shelf-books-education-learning-school-study_svgrepo.com.svg',
                          onPressed: null,
                          description:
                              "The tutor has not inserted any schedules yet.",
                          buttonText: '');
                    } else {
                      return ListView.builder(
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final sched = schedules[index];

                          return ScheduleContainer(
                            date: formatDate(sched.date),
                            startTime: sched.startTime,
                            endTime: sched.endTime,
                            status: sched.status,
                            tuteeId: _firebaseAuth.currentUser!.uid,
                            isChat: true,
                            scheduleId: sched.scheduleId!,
                            classId: classId,
                            tutorId: tutorId,
                          );
                        },
                      );
                    }
                  },
                  error: (error, stackTrace) => Text(
                    error.toString(),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
