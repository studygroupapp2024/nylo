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
              right: 20,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(
                  height: 15,
                  width: 125,
                ),
                SizedBox(
                  height: 10,
                ),
                Skeleton(
                  height: 18,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Skeleton(height: 25, width: 80),
                    SizedBox(
                      width: 10,
                    ),
                    Skeleton(height: 25, width: 80),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

   //                 return Padding(
    //                   padding: const EdgeInsets.only(top: 5),
    //                   child: Shimmer.fromColors(
    //                     baseColor: Colors.grey[400]!,
    //                     highlightColor: Colors.grey[300]!,
    //                     child: const Skeleton(height: 30, width: 80),
    //                   ),
    //                 );