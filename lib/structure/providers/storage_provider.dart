import 'package:hooks_riverpod/hooks_riverpod.dart';

final pathNameProvider = StateProvider<String>((ref) => '');
final fileNameProvider = StateProvider<String>((ref) => '');
final documentTypeProvider = StateProvider<String>((ref) => '');
