import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends StatelessWidget {
  final Alignment alignment;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadiusGeometry? borderRadius;
  final TextAlign? textAlign;
  final double? fontSize;

  final String category;
  final String time;
  final String type;
  final String downloadUrl;
  final String fileName;

  final String senderMessage;
  const ChatBubble({
    super.key,
    required this.alignment,
    required this.senderMessage,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.textAlign,
    required this.fontSize,
    required this.category,
    required this.time,
    required this.type,
    required this.downloadUrl,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        constraints: const BoxConstraints(maxWidth: 250),
        alignment: alignment,
        padding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                textWidthBasis: TextWidthBasis.parent,
                textAlign: textAlign,
                senderMessage,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                ),
              ),
            ),
            if (category == "image" && downloadUrl.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  launchUrl(Uri.parse(downloadUrl),
                      mode: LaunchMode.externalApplication);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(downloadUrl),
                  ),
                ),
              ),
            if (category == "document" && downloadUrl.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  launchUrl(Uri.parse(downloadUrl),
                      mode: LaunchMode.externalApplication);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: textColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.download,
                              color: textColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                fileName,
                                style: TextStyle(
                                  color: textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (type != "announcement")
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  time,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
