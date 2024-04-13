import 'package:flutter/material.dart';

class SelectionCourse extends StatelessWidget {
  final String courseCode;
  final String courseTitle;
  final Color? color;

  const SelectionCourse({
    super.key,
    required this.courseCode,
    required this.courseTitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 15,
            left: 15,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        courseCode,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(courseTitle),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
