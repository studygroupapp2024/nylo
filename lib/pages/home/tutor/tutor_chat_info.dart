import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/chat_info_container.dart';
import 'package:nylo/components/containers/chat_info_containers/chat_info_container_with_switch.dart';
import 'package:nylo/components/image_placeholder/image_placeholder.dart';
import 'package:nylo/pages/home/tutor/scheduler/set_schedule.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/user_provider.dart';
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
    final image = ref.watch(userInfoProvider(creator));

    final subjectMatterInfo = ref.watch(directMessageInfoProvider(classId));
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
                Center(
                  child: Column(
                    children: [
                      image.when(
                        data: (image) {
                          return Column(
                            children: [
                              SizedBox(
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
                                    image.imageUrl != ''
                                        ? CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            backgroundImage:
                                                NetworkImage(image.imageUrl),
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
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                image.name,
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
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
                          return Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400]!,
                              highlightColor: Colors.grey[300]!,
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(.15),
                                radius: 60,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                subjectMatterInfo.when(
                  data: (data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          data.className,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          data.description,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Wrap(
                          spacing: 10,
                          children: data.courseId
                              .map(
                                (e) => Consumer(
                                  builder: (context, ref, child) {
                                    final course = ref.watch(getSubjectInfo(e));

                                    return course.when(
                                      data: (data) {
                                        return Chip(
                                          label: Text(
                                            data.subject_code,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        );
                                      },
                                      error: (error, stackTrace) {
                                        return Center(
                                          child: Text('Error: $error'),
                                        );
                                      },
                                      loading: () {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Created on $dateCreated",
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 10,
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
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
                            color: Theme.of(context).colorScheme.primary),
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
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ChatInfoContainerWithSwitch(
                      groupChatId: groupChatId,
                      onTap: null,
                      title: "Notifications",
                      icon: Icons.notifications,
                      isGroup: false,
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
