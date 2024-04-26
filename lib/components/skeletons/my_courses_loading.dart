import 'package:flutter/material.dart';
import 'package:nylo/components/skeletons/skeleton.dart';

class MyCoursesLoading extends StatelessWidget {
  const MyCoursesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
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
                height: 25,
                width: 150,
              ),
              Skeleton(
                height: 25,
                width: double.infinity,
              )
            ],
          ),
        );
      },
    );
  }
}
