import 'package:flutter/material.dart';
import 'package:nylo/components/skeletons/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryLoading extends StatelessWidget {
  const HomeCategoryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(.15),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black.withOpacity(.15),
                radius: 25,
              ),
              const SizedBox(
                height: 4,
              ),
              const Skeleton(height: 15, width: 75),
              const SizedBox(
                height: 5,
              ),
              const Skeleton(height: 20, width: 125),
            ],
          ),
        ),
      ),
    );
  }
}
