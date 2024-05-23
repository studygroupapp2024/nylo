import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/chat_info_container.dart';
import 'package:nylo/components/containers/chat_info_containers/chat_info_container_with_switch%20copy.dart';
import 'package:nylo/components/dialogs/alert_dialog.dart';
import 'package:nylo/components/image_placeholder/image_placeholder.dart';
import 'package:nylo/components/information_snackbar.dart';
import 'package:nylo/pages/chat/members.dart';
import 'package:nylo/pages/chat/members_request.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatInfo extends ConsumerWidget {
  final String groupChatId;
  final String dateCreated;

  final List<dynamic> members;
  ChatInfo({
    super.key,
    required this.groupChatId,
    required this.members,
    required this.dateCreated,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final group = ref.watch(singleGroupChatInformationProvider(groupChatId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Info"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      group.when(
                        data: (groupInfo) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 125,
                                width: 125,
                                child: GestureDetector(
                                  onTap: members.contains(auth.currentUser!.uid)
                                      ? () async {
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles(
                                            allowMultiple: false,
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'jpg',
                                              'png',
                                            ],
                                          );

                                          if (result == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "No item has been selected."),
                                              ),
                                            );
                                            return;
                                          }
                                          final path = result.files.single.path;
                                          final filename =
                                              result.files.single.name;
                                          ref
                                              .read(groupChatProvider)
                                              .changeGroupChatProfile(
                                                path.toString(),
                                                filename,
                                                groupChatId,
                                                ref.watch(
                                                    setGlobalUniversityId),
                                              );
                                        }
                                      : () {},
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                      ),
                                      groupInfo.groupChatImage != ''
                                          ? CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              backgroundImage: NetworkImage(
                                                  groupInfo.groupChatImage!),
                                              radius: 60,
                                            )
                                          : ImagePlaceholder(
                                              radius: 60,
                                              textColor: Colors.white,
                                              title: groupInfo.courseTitle,
                                              subtitle: "Study Group",
                                              titleFontSize: 12,
                                              subtitleFontSize: 10,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiaryContainer,
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            radius: 13,
                                            child: const Icon(Icons.add),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "About",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                groupInfo.studyGroupDescription,
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 5,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                groupInfo.courseTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Course",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                groupInfo.studyGroupCourseName,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Course Code",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                ),
                                textAlign: TextAlign.left,
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
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      ChatInfoContainer(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Members(
                                                groupChatId: groupChatId,
                                                creatorId: groupInfo.creatorId,
                                                groupChatTitle:
                                                    groupInfo.courseTitle,
                                              ),
                                            ),
                                          );
                                        },
                                        title: "Members",
                                        icon: Icons.supervised_user_circle,
                                        chevron: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (auth.currentUser!.uid ==
                                          groupInfo.creatorId)
                                        ChatInfoContainer(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MembersRequest(
                                                        groupChatId:
                                                            groupChatId,
                                                        groupChatTitle:
                                                            groupInfo
                                                                .courseTitle),
                                              ),
                                            );
                                          },
                                          title: "Request",
                                          icon: Icons.person_add,
                                          chevron: true,
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Settings",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                                      isGroup: true,
                                      receivedNotification: groupInfo
                                          .members![_auth.currentUser!.uid]!
                                          .receiveNotification),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (members.length == 1 &&
                                          groupInfo.creatorId ==
                                              auth.currentUser!.uid ||
                                      members.length != 1 &&
                                          groupInfo.creatorId !=
                                              auth.currentUser!.uid)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Others",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (groupInfo.creatorId ==
                                          auth.currentUser!.uid &&
                                      members.length == 1)
                                    ChatInfoContainer(
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ConfirmationDialog(
                                            confirm: () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .popUntil(
                                                ModalRoute.withName(
                                                    "/ChatOption"),
                                              );

                                              informationSnackBar(
                                                context,
                                                Icons.notifications,
                                                "${groupInfo.studyGroupTitle} has been deleted.",
                                              );

                                              await ref
                                                  .read(groupChatProvider)
                                                  .removeStudyGroup(
                                                    groupChatId,
                                                    ref.watch(
                                                        setGlobalUniversityId),
                                                    groupInfo.creatorId,
                                                  );
                                            },
                                            content:
                                                "Are you sure you want to delete this chat?",
                                            title: "Confirmation",
                                            type: "Yes",
                                          );
                                        },
                                      ),
                                      title: "Remove Chat",
                                      icon: Icons.exit_to_app,
                                      chevron: false,
                                    ),
                                  if (groupInfo.creatorId !=
                                          auth.currentUser!.uid &&
                                      members.contains(
                                        auth.currentUser!.uid,
                                      ))
                                    ChatInfoContainer(
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ConfirmationDialog(
                                            confirm: () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .popUntil(
                                                ModalRoute.withName(
                                                    "/ChatOption"),
                                              );

                                              informationSnackBar(
                                                context,
                                                Icons.notifications,
                                                "You have left the ${groupInfo.studyGroupTitle} chat.",
                                              );

                                              await ref
                                                  .read(groupChatProvider)
                                                  .removeMember(
                                                    groupChatId,
                                                    auth.currentUser!.uid,
                                                    ref.watch(
                                                        setGlobalUniversityId),
                                                    "left",
                                                    auth.currentUser!
                                                        .displayName
                                                        .toString(),
                                                    groupInfo.studyGroupTitle,
                                                    groupInfo.creatorId,
                                                  );
                                            },
                                            content:
                                                "Are you sure you want to leave this chat?",
                                            title: "Confirmation",
                                            type: "Yes",
                                          );
                                        },
                                      ),
                                      title: "Leave chat",
                                      icon: Icons.exit_to_app,
                                      chevron: false,
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    groupInfo.studyGroupTitle,
                                    style: const TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
