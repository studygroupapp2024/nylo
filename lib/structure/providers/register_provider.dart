import 'package:hooks_riverpod/hooks_riverpod.dart';

final lastPageProvider = StateProvider.autoDispose<bool>((ref) => false);
final firstPageProvider = StateProvider.autoDispose<bool>((ref) => true);
final selectedIndexProvider = StateProvider.autoDispose<int>((ref) => -1);
final emailDomainProvider = StateProvider<String>((ref) => '');

final universityNameProvider = StateProvider<String>((ref) => '');
final universityIdProvider = StateProvider<String>((ref) => '');

final dropDownValueProvider = StateProvider<String>((ref) => '');
final dropDownListProvider = StateProvider<List<String>>((ref) => []);
