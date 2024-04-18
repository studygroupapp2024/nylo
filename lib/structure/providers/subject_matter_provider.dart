import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/services/subject_matter_services.dart';

final subjectMatterProvider = StateProvider.autoDispose<SubjectMatter>((ref) {
  return SubjectMatter();
});
