import 'package:flutter/material.dart';
import 'package:nylo/components/chats/time.dart';
import 'package:nylo/pages/home/tutor/components/chips/subject_chip.dart';
import 'package:nylo/pages/home/tutor/components/text/bold_text.dart';
import 'package:nylo/structure/models/direct_message_model.dart';

class TutorChatContainer extends StatelessWidget {
  const TutorChatContainer({
    super.key,
    required this.chatIds,
    required this.firstName,
    required this.format,
    required this.image,
    required this.name,
  });

  final DirectMessageModel chatIds;
  final String firstName;
  final String format;
  final String image;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              image,
            ),
            radius: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatIds.className),
                const SizedBox(height: 5),
                SubjectChip(
                  subjects: chatIds.subjects!,
                ),
                BoldText(text: name),
                const SizedBox(height: 4),
                chatIds.lastMessageTimeSent != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          chatIds.lastMessageSender == name
                              ? Text(
                                  "${firstName.substring(0, 1).toUpperCase()}${firstName.substring(1).toLowerCase()}: $format",
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  "You: $format",
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          Time(time: chatIds.lastMessageTimeSent!),
                        ],
                      )
                    : Text(
                        chatIds.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
