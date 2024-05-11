import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/image_placeholder/image_placeholder.dart';

import '../buttons/rounded_button_with_progress.dart';

class StudyGroupContainer extends ConsumerWidget {
  final void Function()? onTap;
  final String title;
  final String desc;
  final String members;
  final String identifier;
  final String? image;
  final String subjectCode;
  final String subjectTitle;
  final String groupChatImage;

  const StudyGroupContainer({
    super.key,
    required this.onTap,
    required this.title,
    required this.desc,
    required this.members,
    required this.identifier,
    required this.image,
    required this.subjectCode,
    required this.subjectTitle,
    required this.groupChatImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(2, 5),
                  color: Colors.black.withOpacity(0.1),
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          groupChatImage != ''
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  padding: const EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(groupChatImage),
                                    radius: 100,
                                  ),
                                )
                              : ImagePlaceholder(
                                  width: 100,
                                  height: 100,
                                  radius: 100,
                                  title: subjectCode,
                                  subtitle: "Study Group",
                                  titleFontSize: 8,
                                  subtitleFontSize: 6,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  desc,
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      subjectCode,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        subjectTitle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.account_box_outlined),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      members,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundedButtonWithProgress(
                  text: identifier,
                  onTap: onTap,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  textcolor: Theme.of(context).colorScheme.background,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
