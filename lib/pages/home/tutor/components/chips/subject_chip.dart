import 'package:flutter/material.dart';
import 'package:nylo/structure/services/subject_matter_services.dart';

class SubjectChip extends StatelessWidget {
  final Map<String, Subject> subjects;
  const SubjectChip({
    super.key,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: subjects.values.map((subject) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(
              subject.subjectCode,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
