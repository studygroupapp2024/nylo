import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/member_request_decision_container.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/tutor_schedules_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class ScheduleContainer extends ConsumerWidget {
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String? tuteeId;
  final bool? isChat;
  final String? scheduleId;
  final String classId;
  final String? tutorId;
  final String? tuteeName;
  const ScheduleContainer({
    super.key,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.tuteeId,
    required this.isChat,
    this.scheduleId,
    required this.classId,
    this.tutorId,
    this.tuteeName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              left: BorderSide(
                color: ScheduleStatus.setColor(status), // Color of the border
                width: 5, // Width of the border
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      "$startTime - $endTime",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ScheduleStatus.setColor(status),
                      radius: 3,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      status.capitalizeFirst!,
                      style: TextStyle(
                        color: ScheduleStatus.setColor(status),
                      ),
                    ),
                  ],
                )
              ],
            ),
            if ((tuteeId != null && status == "booked") || isChat == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: .3,
                    color: ScheduleStatus.setColor(status),
                  ),
                  // const SizedBox(
                  //   height: 4,
                  // ),
                  if (!isChat!)
                    Text("$tuteeName would like to be your student."),
                  if (!isChat!)
                    const SizedBox(
                      height: 8,
                    ),
                  Row(
                    children: [
                      if (!isChat!)
                        MemberRequestDecisionContainer(
                          text: "Decline",
                          onTap: () async {
                            final loadingNotifier =
                                ref.read(isLoadingProvider.notifier);
                            final schedulesProvider =
                                ref.read(tutorSchedulesProvider);
                            final globalUniversitySetter =
                                ref.watch(setGlobalUniversityId);

                            loadingNotifier.update((state) => true);

                            await schedulesProvider.rejectBooking(
                              scheduleId!,
                              tuteeId!,
                              globalUniversitySetter,
                              classId,
                            );

                            loadingNotifier.update((state) => false);
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          iconColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          textColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          icon: Icons.remove_circle_outline,
                        ),
                      if (!isChat!)
                        const SizedBox(
                          width: 4,
                        ),
                      MemberRequestDecisionContainer(
                        text: isChat! ? "Book" : "Accept",
                        onTap: isChat!
                            ? () async {
                                final loadingNotifier =
                                    ref.read(isLoadingProvider.notifier);
                                final schedulesProvider =
                                    ref.read(tutorSchedulesProvider);
                                final globalUniversitySetter =
                                    ref.watch(setGlobalUniversityId);

                                loadingNotifier.update((state) => true);

                                await schedulesProvider.bookSchedule(
                                  scheduleId!,
                                  tuteeId!,
                                  globalUniversitySetter,
                                  classId,
                                  tutorId,
                                );
                                loadingNotifier.update((state) => false);

                                // final ScaffoldMessengerState messenger =
                                //     ScaffoldMessenger.of(context);
                                // if (result) {
                                //   informationSnackBar(
                                //     context,
                                //     messenger,
                                //     Icons.notifications,
                                //     "The request has been sent to the tutor.",
                                //   );
                                // }
                              }
                            : () async {
                                final loadingNotifier =
                                    ref.read(isLoadingProvider.notifier);
                                final schedulesProvider =
                                    ref.read(tutorSchedulesProvider);
                                final globalUniversitySetter =
                                    ref.watch(setGlobalUniversityId);

                                loadingNotifier.update((state) => true);

                                await schedulesProvider.acceptBooking(
                                  scheduleId!,
                                  tuteeId!,
                                  globalUniversitySetter,
                                  classId,
                                );

                                loadingNotifier.update((state) => false);
                              },
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        iconColor: Theme.of(context).colorScheme.background,
                        textColor: Theme.of(context).colorScheme.background,
                        icon: isChat!
                            ? Icons.approval
                            : Icons.check_circle_outline,
                      ),
                    ],
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}

class ScheduleStatus {
  static setColor(String status) {
    switch (status) {
      case 'available':
        return Colors.grey;
      case 'booked':
        return Colors.green;
      case 'occupied':
        return Colors.red;
    }
  }
}
