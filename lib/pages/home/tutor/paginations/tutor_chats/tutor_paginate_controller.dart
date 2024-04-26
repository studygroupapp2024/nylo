import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/paginations/tutor_chats/tutor_pagination_provider.dart';
import 'package:nylo/structure/models/chat_model.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class TutorChatsPaginateController extends AsyncNotifier<List<MessageModel>> {
  final pageSize = 10;
  bool hasMore = true;
  DocumentSnapshot? lastDoc;
  @override
  FutureOr<List<MessageModel>> build() async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard((fetchTutorChats));

    state = newState;
    return newState.value ?? [];
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !hasMore || lastDoc == null) return;

    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() async {
      final newSubjects = await fetchTutorChats();
      return [...state.value!, ...newSubjects];
    });

    state = newState;
  }

  Future<List<MessageModel>> fetchTutorChats() async {
    await Future.delayed(const Duration(seconds: 1));
    final result =
        await ref.read(tutorAppSubjectRepositoryProvider).fetchTutorChats(
              pageSize: pageSize,
              institutionId: ref.watch(setGlobalUniversityId),
              lastDoc: lastDoc,
            );
    hasMore = result.$1.isNotEmpty;
    final lastDocument = result.$2;

    if (lastDocument != null) {
      lastDoc = lastDocument;
    }

    return result.$1;
  }
}

final tutorPaginateControllerProvider =
    AsyncNotifierProvider<TutorChatsPaginateController, List<MessageModel>>(
  TutorChatsPaginateController.new,
);
