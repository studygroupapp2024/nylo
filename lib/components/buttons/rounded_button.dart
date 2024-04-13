import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';

class RoundedButton extends ConsumerWidget {
  final void Function()? onTap;
  final String text;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? textcolor;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.margin,
    required this.color,
    required this.textcolor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);

    return Stack(
      children: [
        GestureDetector(
          onTap: isLoading ? () {} : onTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            margin: margin,
            child: Center(
              child: Text(
                text,
                style: TextStyle(color: textcolor),
              ),
            ),
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
