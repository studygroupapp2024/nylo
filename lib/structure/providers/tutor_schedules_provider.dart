import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/services/tutor_schedule_services.dart';

final dateControllerProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);
final startTimeControllerProvider = StateProvider<TimeOfDay>(
  (ref) => TimeOfDay.now(),
);
final endTimeControllerProvider = StateProvider<TimeOfDay>(
  (ref) => TimeOfDay.now(),
);

final tutorSchedulesProvider =
    StateProvider.autoDispose<TutorScheduleService>((ref) {
  return TutorScheduleService();
});
