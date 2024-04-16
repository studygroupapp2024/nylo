import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';

final selectedCoursesToTeachProvider =
    StateProvider<List<SelectedCoursesToTeachModel>>((ref) => []);
