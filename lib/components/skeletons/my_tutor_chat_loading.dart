import 'package:flutter/material.dart';
import 'package:nylo/components/skeletons/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class TutorChatLoading extends StatelessWidget {
  const TutorChatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 50,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(
                    height: 20,
                    width: 75,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Skeleton(
                        height: 20,
                        width: 64,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Skeleton(
                        height: 20,
                        width: 64,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Skeleton(
                    height: 15,
                    width: 150,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Skeleton(
                    height: 18,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
