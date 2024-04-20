import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/chat_info_containers/chat_info_container_with_switch.dart';
import 'package:nylo/components/image_placeholder/image_placeholder.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class TutorChatInfo extends ConsumerWidget {
  final String groupChatId;
  final String creator;
  final String groupChatTitle;
  final String dateCreated;
  final String classId;

  final List<dynamic> members;
  const TutorChatInfo({
    super.key,
    required this.groupChatId,
    required this.creator,
    required this.groupChatTitle,
    required this.dateCreated,
    required this.members,
    required this.classId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final image = ref.watch(userInfoProvider(creator));
    print("classID: $classId");
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
              bottom: 0,
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
                                        : const ImagePlaceholder(
                                            title: "HAHA",
                                            subtitle: "Study Group",
                                            titleFontSize: 12,
                                            subtitleFontSize: 10,
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
                          return const Center(
                            child: CircularProgressIndicator(),
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
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "HAHA",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 5,
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
                        const Text(
                          "HAHA",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "Course",
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
                        const Text(
                          "HAHA",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "Course Code",
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          textAlign: TextAlign.left,
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
                Text(
                  "Chat",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  height: 10,
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
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // if (members.length == 1 &&
                    //         creator == auth.currentUser!.uid ||
                    //     members.length != 1 && creator != auth.currentUser!.uid)
                    //   Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       "Others",
                    //       style: TextStyle(
                    //         color: Theme.of(context).colorScheme.primary,
                    //       ),
                    //     ),
                    //   ),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //     if (creator == auth.currentUser!.uid && members.length == 1)
                    //       ChatInfoContainer(
                    //         onTap: () => showDialog(
                    //           context: context,
                    //           builder: (context) {
                    //             return ConfirmationDialog(
                    //               confirm: () async {
                    //                 Navigator.of(context, rootNavigator: true)
                    //                     .popUntil(
                    //                   ModalRoute.withName("/ChatOption"),
                    //                 );

                    //                 ScaffoldMessenger.of(context).showSnackBar(
                    //                   SnackBar(
                    //                     content: Row(
                    //                       children: [
                    //                         Icon(
                    //                           Icons.notifications,
                    //                           color: Theme.of(context)
                    //                               .colorScheme
                    //                               .tertiaryContainer,
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 10,
                    //                         ),
                    //                         Text(
                    //                           "$groupChatTitle has been deleted.",
                    //                           style: TextStyle(
                    //                             color: Theme.of(context)
                    //                                 .colorScheme
                    //                                 .tertiaryContainer,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     behavior: SnackBarBehavior.floating,
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius: BorderRadius.circular(20),
                    //                     ),
                    //                     backgroundColor:
                    //                         Theme.of(context).colorScheme.tertiary,
                    //                     elevation: 4,
                    //                     padding: const EdgeInsets.all(20),
                    //                   ),
                    //                 );

                    //                 await ref
                    //                     .read(groupChatProvider)
                    //                     .removeStudyGroup(
                    //                       groupChatId,
                    //                       ref.watch(setGlobalUniversityId),
                    //                       creator,
                    //                     );
                    //               },
                    //               content:
                    //                   "Are you sure you want to delete this chat?",
                    //               title: "Confirmation",
                    //               type: "Yes",
                    //             );
                    //           },
                    //         ),
                    //         title: "Remove Chat",
                    //         icon: Icons.exit_to_app,
                    //         chevron: false,
                    //       ),
                    //     if (creator != auth.currentUser!.uid &&
                    //         members.contains(
                    //           auth.currentUser!.uid,
                    //         ))
                    //       ChatInfoContainer(
                    //         onTap: () => showDialog(
                    //           context: context,
                    //           builder: (context) {
                    //             return ConfirmationDialog(
                    //               confirm: () async {
                    //                 Navigator.of(context, rootNavigator: true)
                    //                     .popUntil(
                    //                   ModalRoute.withName("/ChatOption"),
                    //                 );

                    //                 ScaffoldMessenger.of(context).showSnackBar(
                    //                   SnackBar(
                    //                     content: Row(
                    //                       children: [
                    //                         Icon(
                    //                           Icons.notifications,
                    //                           color: Theme.of(context)
                    //                               .colorScheme
                    //                               .tertiaryContainer,
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 10,
                    //                         ),
                    //                         Text(
                    //                           "You have left the $groupChatTitle",
                    //                           style: TextStyle(
                    //                             color: Theme.of(context)
                    //                                 .colorScheme
                    //                                 .tertiaryContainer,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     behavior: SnackBarBehavior.floating,
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius: BorderRadius.circular(20),
                    //                     ),
                    //                     backgroundColor:
                    //                         Theme.of(context).colorScheme.tertiary,
                    //                     elevation: 4,
                    //                     padding: const EdgeInsets.all(20),
                    //                   ),
                    //                 );

                    //                 await ref.read(groupChatProvider).removeMember(
                    //                       groupChatId,
                    //                       auth.currentUser!.uid,
                    //                       ref.watch(setGlobalUniversityId),
                    //                       "left",
                    //                       auth.currentUser!.displayName.toString(),
                    //                       groupChatTitle,
                    //                       creator,
                    //                     );
                    //               },
                    //               content:
                    //                   "Are you sure you want to leave this chat?",
                    //               title: "Confirmation",
                    //               type: "Yes",
                    //             );
                    //           },
                    //         ),
                    //         title: "Leave chat",
                    //         icon: Icons.exit_to_app,
                    //         chevron: false,
                    //       ),
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
