import 'package:flutter/material.dart';
import 'package:nylo/pages/home/tutor/add_schedule.dart';

class ViewSchedule extends StatelessWidget {
  final String classId;
  final String tutorId;
  const ViewSchedule({
    super.key,
    required this.classId,
    required this.tutorId,
  });

  @override
  Widget build(BuildContext context) {
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
                          )));
            },
            icon: const Icon(Icons.schedule),
          ),
        ],
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
