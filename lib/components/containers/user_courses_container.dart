import 'package:flutter/material.dart';

class MyCoursesContainer extends StatelessWidget {
  final String courseCode;
  final String courseTitle;
  final void Function() onTap;
  final Icon icon;
  const MyCoursesContainer({
    super.key,
    required this.courseCode,
    required this.courseTitle,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
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
              IconButton(
                onPressed: onTap,
                icon: icon,
              )
            ],
          ),
        ),
      ),
    );
  }
}
