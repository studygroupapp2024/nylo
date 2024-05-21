import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/chat_info_container.dart';
import 'package:nylo/components/containers/chat_info_containers/chat_info_container_with_switch%20copy.dart';
import 'package:nylo/components/image_placeholder/image_placeholder.dart';
import 'package:nylo/components/skeletons/skeleton.dart';
import 'package:nylo/pages/home/tutor/components/chips/subject_chip.dart';
import 'package:nylo/pages/home/tutor/scheduler/set_schedule.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:shimmer/shimmer.dart';

class TutorChatInfo extends ConsumerWidget {
  final String groupChatId;
  final String creator;
  final String groupChatTitle;
  final String dateCreated;
  final String classId;

  final List<dynamic> members;
  TutorChatInfo({
    super.key,
    required this.groupChatId,
    required this.creator,
    required this.groupChatTitle,
    required this.dateCreated,
    required this.members,
    required this.classId,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directMessageProvider =
        ref.watch(directMessageMemberInfoProvider(groupChatId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Info"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    directMessageProvider.when(
                      data: (directMessageInfo) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 125,
                                width: 125,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                    ),
                                    directMessageInfo
                                                .members![
                                                    _auth.currentUser!.uid]!
                                                .imageUrl !=
                                            ''
                                        ? CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            backgroundImage: NetworkImage(
                                                directMessageInfo
                                                    .members![
                                                        _auth.currentUser!.uid]!
                                                    .imageUrl),
                                            radius: 58,
                                          )
                                        : ImagePlaceholder(
                                            height: 60,
                                            width: 60,
                                            radius: 60,
                                            title: "NYLO",
                                            titleFontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiaryContainer,
                                            textColor: Colors.white,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                directMessageInfo
                                    .members![_auth.currentUser!.uid]!.name,
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "About",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  directMessageInfo.className,
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  directMessageInfo.classDescription,
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SubjectChip(
                                    subjects: directMessageInfo.subjects!),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Created on $dateCreated",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (_auth.currentUser!.uid != creator)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Schedule",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ChatInfoContainer(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SetSchedule(
                                            classId: classId,
                                            tutorId: creator,
                                          ),
                                        ),
                                      );
                                    },
                                    title: "Set a meeting",
                                    icon: Icons.schedule,
                                    chevron: true,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Settings",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                NotificationSwitch(
                                  groupChatId: groupChatId,
                                  onTap: null,
                                  title: "Notifications",
                                  icon: Icons.notifications,
                                  isGroup: false,
                                  receivedNotification: directMessageInfo
                                      .members![_auth.currentUser!.uid]!
                                      .receiveNotification,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      error: (error, stackTrace) {
                        return Center(
                          child: Text('Error: $error'),
                        );
                      },
                      loading: () {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[400]!,
                          highlightColor: Colors.grey[300]!,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          Colors.black.withOpacity(.15),
                                      radius: 60,
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    const Skeleton(height: 25, width: 175),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Skeleton(height: 25, width: 75),
                              const SizedBox(
                                height: 10,
                              ),
                              const Skeleton(height: 30, width: 200),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  Skeleton(height: 25, width: 125),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Skeleton(height: 25, width: 125),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Skeleton(height: 25, width: 100),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 20,
                              ),
                              const Skeleton(height: 25, width: 75),
                              const SizedBox(
                                height: 10,
                              ),
                              const Skeleton(
                                  height: 50, width: double.infinity),
                              const SizedBox(
                                height: 10,
                              ),
                              const Skeleton(height: 25, width: 75),
                              const SizedBox(
                                height: 10,
                              ),
                              const Skeleton(height: 50, width: double.infinity)
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
