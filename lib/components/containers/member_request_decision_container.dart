import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';

class MemberRequestDecisionContainer extends ConsumerWidget {
  const MemberRequestDecisionContainer({
    super.key,
    required this.text,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });

  final String text;
  final void Function()? onTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    return Stack(
      children: [
        GestureDetector(
          onTap: isLoading ? () {} : onTap,
          child: IntrinsicWidth(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: iconColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
