import 'package:flutter/material.dart';
import 'package:nylo/components/skeletons/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class MyCoursesLoading extends StatelessWidget {
  const MyCoursesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(
          height: 25,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 50,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(
                  height: 15,
                  width: 150,
                ),
                SizedBox(
                  height: 10,
                ),
                Skeleton(
                  height: 18,
                  width: double.infinity,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
