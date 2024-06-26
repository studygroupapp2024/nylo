import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double titleFontSize;
  final double? subtitleFontSize;
  final Color color;
  final Color textColor;
  final double? height;
  final double? width;
  final double radius;

  const ImagePlaceholder({
    super.key,
    required this.title,
    this.subtitle,
    required this.titleFontSize,
    this.subtitleFontSize,
    required this.color,
    required this.textColor,
    this.height,
    this.width,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(5),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: textColor,
                ),
              ),
            ),
            Text(
              subtitle ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
