import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';

class TutorCoursesChip extends ConsumerWidget {
  final SubjectMatterModel groupChats;
  const TutorCoursesChip({
    super.key,
    required this.groupChats,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
    // return Wrap(
    //   spacing: 10,
    //   children: groupChats.courseId
    //       .map(
    //         (e) => Consumer(
    //           builder: (context, ref, child) {
    //             final course = ref.watch(getSubjectInfo(e));

    //             return course.when(
    //               data: (data) {
    //                 return Container(
    //                   margin: const EdgeInsets.symmetric(vertical: 5),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(20),
    //                     border: Border.all(
    //                       color:
    //                           Theme.of(context).colorScheme.tertiaryContainer,
    //                     ),
    //                   ),
    //                   child: Padding(
    //                     padding: const EdgeInsets.symmetric(
    //                       vertical: 5,
    //                       horizontal: 10,
    //                     ),
    //                     child: Text(
    //                       data.subject_code,
    //                       style: const TextStyle(
    //                         fontSize: 12,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 );
    //               },
    //               error: (error, stackTrace) {
    //                 return Center(
    //                   child: Text('Error: $error'),
    //                 );
    //               },
    //               loading: () {
    //                 return Padding(
    //                   padding: const EdgeInsets.only(top: 5),
    //                   child: Shimmer.fromColors(
    //                     baseColor: Colors.grey[400]!,
    //                     highlightColor: Colors.grey[300]!,
    //                     child: const Skeleton(height: 30, width: 80),
    //                   ),
    //                 );
    //               },
    //             );
    //           },
    //         ),
    //       )
    //       .toList(),
    // );
  }
}
