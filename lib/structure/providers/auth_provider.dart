import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/auth/auth_service.dart';

final authProvider = StateProvider.autoDispose<AuthService>((ref) {
  return AuthService();
});
