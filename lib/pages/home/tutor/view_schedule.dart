import 'package:flutter/material.dart';
import 'package:nylo/pages/home/tutor/add_schedule.dart';

class ViewSchedule extends StatelessWidget {
  const ViewSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddSchedule()));
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
