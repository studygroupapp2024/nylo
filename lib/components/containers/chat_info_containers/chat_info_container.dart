import 'package:flutter/material.dart';

class ChatInfoContainer extends StatelessWidget {
  const ChatInfoContainer({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    required this.chevron,
  });

  final Function()? onTap;
  final String title;
  final IconData icon;
  final bool chevron;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                if (chevron)
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
              ],
            )),
      ),
    );
  }
}
