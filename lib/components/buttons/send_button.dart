import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';

class SendButton extends ConsumerWidget {
  final void Function() onPressed;
  const SendButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);

    return IconButton(
        onPressed: isLoading ? () {} : onPressed, icon: const Icon(Icons.send));
  }
}
