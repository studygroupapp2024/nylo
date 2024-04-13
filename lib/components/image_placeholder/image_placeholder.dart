import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;
  final double titleFontSize;
  final double subtitleFontSize;

  const ImagePlaceholder({
    super.key,
    required this.title,
    required this.subtitle,
    required this.titleFontSize,
    required this.subtitleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      padding: const EdgeInsets.all(5),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
