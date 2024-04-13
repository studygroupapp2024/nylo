import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/member_request_decision_container.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class MembersRequest extends ConsumerWidget {
  final String groupChatId;
  final String groupChatTitle;

  const MembersRequest({
    super.key,
    required this.groupChatId,
    required this.groupChatTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final memberRequestModel = ref.watch(
      singleGroupChatInformationProvider(groupChatId),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member Request"),
        centerTitle: true,
      ),
      body: memberRequestModel.when(
        data: (memberRequests) {
          if (memberRequests.membersRequestId.isEmpty) {
            return Center(
              child: Text("No member request",
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.tertiaryContainer)),
            );
          } else {
            return auth.currentUser!.uid == memberRequests.creatorId
                ? ListView.builder(
                    itemCount: memberRequests.membersRequestId.length,
                    itemBuilder: (context, index) {
                      final memberRequestId =
                          memberRequests.membersRequestId[index];

                      final userInfo =
                          ref.watch(userInfoProvider(memberRequestId));

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: userInfo.when(
                            data: (data) => Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        data.imageUrl,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          data.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    MemberRequestDecisionContainer(
                                      text: "Deny",
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      icon: Icons.remove_circle_outline,
                                      onTap: () async {
                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = true;

                                        await ref
                                            .read(
                                                groupChatMemberRequestProvider)
                                            .acceptOrreject(
                                              groupChatId,
                                              memberRequestId,
                                              false,
                                              groupChatTitle,
                                              ref.watch(setGlobalUniversityId),
                                            );

                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = false;
                                      },
                                    ),

                                    //
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    MemberRequestDecisionContainer(
                                      text: "Accept",
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      icon: Icons.check_circle_outline,
                                      onTap: () async {
                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = true;

                                        await ref
                                            .read(
                                                groupChatMemberRequestProvider)
                                            .acceptOrreject(
                                              groupChatId,
                                              memberRequestId,
                                              true,
                                              groupChatTitle,
                                              ref.watch(setGlobalUniversityId),
                                            );

                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = false;
                                      },
                                    ),
                                  ],
                                ),
                            error: (error, stackTrace) =>
                                Text(error.toString()),
                            loading: () => const CircularProgressIndicator()),
                      );
                    },
                  )
                : Container();
          }
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
