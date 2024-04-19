import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/services/direct_message_services.dart';

final directMessageProvider = StateProvider.autoDispose<DirectMessage>((ref) {
  return DirectMessage();
});
