import 'package:flutter/material.dart';
import 'package:nylo/components/skeletons/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class StudyGroupChatLoading extends StatelessWidget {
  const StudyGroupChatLoading({super.key});

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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.black.withOpacity(.15),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(
                        height: 15,
                        width: 100,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Skeleton(
                        height: 18,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Skeleton(
                        height: 15,
                        width: 60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
