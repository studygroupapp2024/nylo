import 'package:flutter/material.dart';

// Information SnackBar, used to show information using a snackbar
void informationSnackBar(
  BuildContext context,
  ScaffoldMessengerState messenger,
  IconData icon,
  String text,
) {
  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      elevation: 4,
      padding: const EdgeInsets.all(20),
    ),
  );
}
