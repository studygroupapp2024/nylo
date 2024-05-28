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
    final group = ref.watch(singleGroupChatInformationProvider(groupChatId));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Members"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return group.when(
            data: (groupchat) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: groupchat.members!.length,
                itemBuilder: (context, index) {
                  final values = groupchat.members!.values.toList();
                  final keys = groupchat.members!.keys.toList();
                  final userKey = keys[index];
                  final members = values[index];
                  return MembersContainer(
                    member: members.name, // Use the individual member
                    role: members.isAdmin
                        ? "Admin"
                        : "Member", // Check the role for each member
                    image: members.imageUrl,
                    isAdmin: members.isAdmin,
                    creatorId: groupchat.creatorId,
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            confirm: () async {
                              ref.read(groupChatProvider).removeMember(
                                    groupChatId,
                                    userKey,
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
