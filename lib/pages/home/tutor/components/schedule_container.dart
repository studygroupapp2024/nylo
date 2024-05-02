import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylo/components/containers/member_request_decision_container.dart';

class ScheduleContainer extends StatelessWidget {
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String? tuteeName;
  const ScheduleContainer({
    super.key,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.tuteeName,
  });

  @override
  Widget build(BuildContext context) {
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
            if (tuteeName != null)
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
                  Text("$tuteeName would like to be your students."),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      MemberRequestDecisionContainer(
                        text: "Decline",
                        onTap: null,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        iconColor: Theme.of(context).colorScheme.inversePrimary,
                        textColor: Theme.of(context).colorScheme.inversePrimary,
                        icon: Icons.remove_circle_outline,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      MemberRequestDecisionContainer(
                        text: "Accept",
                        onTap: null,
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        iconColor: Theme.of(context).colorScheme.background,
                        textColor: Theme.of(context).colorScheme.background,
                        icon: Icons.check_circle_outline,
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
