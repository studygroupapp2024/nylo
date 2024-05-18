import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  final String text;
  final double? fontSize;
  const BoldText({
    super.key,
    required this.text,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 16,
      ),
    );
  }
}
