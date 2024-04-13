import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/members_container.dart';
import 'package:nylo/components/dialogs/alert_dialog.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class Members extends ConsumerWidget {
  final String groupChatId;
  final String creatorId;
  final String groupChatTitle;

  const Members({
    super.key,
    required this.groupChatId,
    required this.creatorId,
    required this.groupChatTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupChatMembers = ref.watch(
      groupChatMembersProvider(groupChatId),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return groupChatMembers.when(
            data: (membersList) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: membersList.length,
                itemBuilder: (context, index) {
                  final members = membersList[index];

                  return MembersContainer(
                    member: members.name,
                    role: members.isAdmin ? "Admin" : "Member",
                    image: members.imageUrl,
                    isAdmin: members.isAdmin,
                    creatorId: creatorId,
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            confirm: () async {
                              ref.read(groupChatProvider).removeMember(
                                    groupChatId,
                                    members.userId,
                                    ref.watch(setGlobalUniversityId),
                                    "kick",
                                    members.name,
                                    groupChatTitle,
                                    creatorId,
                                  );
                            },
                            content:
                                "Are you sure you want to remove this member?",
                            title: "Confirmation",
                            type: "Yes",
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text('Error: $error'),
              );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
