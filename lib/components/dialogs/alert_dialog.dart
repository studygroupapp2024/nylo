import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final void Function()? confirm;
  final String content;
  final String title;
  final String type;

  const ConfirmationDialog(
      {super.key,
      required this.confirm,
      required this.content,
      required this.title,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            confirm?.call();
            Navigator.of(context).pop();
          },
          child: Text(type),
        ),
      ],
    );
  }
}
