import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/subject_model.dart';
import 'package:nylo/structure/providers/subjects.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class PaginateController extends AsyncNotifier<List<SubjectModel>> {
  final pageSize = 10;
  bool hasMore = true;
  DocumentSnapshot? lastDoc;
  @override
  FutureOr<List<SubjectModel>> build() async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard((fetchSubjects));

    state = newState;
    return newState.value ?? [];
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !hasMore || lastDoc == null) return;

    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() async {
      final newSubjects = await fetchSubjects();
      return [...state.value!, ...newSubjects];
    });

    state = newState;
  }

  Future<List<SubjectModel>> fetchSubjects() async {
    await Future.delayed(const Duration(seconds: 1));
    final result = await ref.read(appSubjectRepositoryProvider).fetchSubjects(
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

final paginateControllerProvider =
    AsyncNotifierProvider<PaginateController, List<SubjectModel>>(
  PaginateController.new,
);
