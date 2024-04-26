import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/paginations/tutor_chats/tutor_paginate_controller.dart';

class TutorChatsPagination extends HookConsumerWidget {
  const TutorChatsPagination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsValue = ref.watch(tutorPaginateControllerProvider);
    final subjects = subjectsValue.value ?? [];
    final isInitialLoading = subjectsValue.isLoading && subjects.isEmpty;

    final controller = useScrollController();
    final paginatorController =
        ref.watch(tutorPaginateControllerProvider.notifier);
    final hasMore = paginatorController.hasMore;
    final isFetchingMore = subjectsValue.isLoading && subjects.isNotEmpty;

    void onScroll() {
      final bool isBottom =
          controller.offset >= controller.position.maxScrollExtent &&
              !controller.position.outOfRange;

      if (isBottom && hasMore && !isFetchingMore) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(tutorPaginateControllerProvider.notifier).fetchMore();
        });
      }
    }

    useEffect(() {
      controller.addListener(onScroll);
      return () => controller.removeListener(onScroll);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagination"),
        centerTitle: true,
      ),
      body: isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: controller,
                      itemCount: subjects.length +
                          (!hasMore || isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (subjects.length == index) {
                          if (isFetchingMore) {
                            return const Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (!hasMore) {
                            return const Center(
                              child: Text("No more subjects"),
                            );
                          } else {
                            return Container();
                          }
                        }
                        return IntrinsicHeight(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                            child: Text(subjects[index].message),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
