import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nylo/components/image_placeholder/image_placeholder.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/components/skeletons/my_study_group_loading.dart';
import 'package:nylo/pages/chat/chat_page.dart';
import 'package:nylo/pages/home/study_group/search_study_group.dart';
import 'package:nylo/structure/auth/login_or_register.dart';
import 'package:nylo/structure/providers/auth_provider.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/chat_services.dart';

class FindPage extends ConsumerWidget {
  FindPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        data: (data) {
          if (data == null) {
            return const LoginOrRegister();
          } else {
            final userGroupIds =
                ref.watch(userChatIdsProvider(_auth.currentUser!.uid));

            return Scaffold(
              appBar: AppBar(
                title: const Text("Study Groups"),
                centerTitle: true,
              ),
              body: Consumer(
                builder: (context, ref, child) {
                  return userGroupIds.when(
                    data: (ids) {
                      if (ids.isEmpty) {
                        return NoContent(
                            icon: 'assets/icons/search-phone_svgrepo.com.svg',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FindStudyGroup(),
                                ),
                              );
                            },
                            description:
                                "It seems like you have no study groups yet. Do you want to find one?",
                            buttonText: "Find Study Group");
                      } else {
                        return ListView.builder(
                          itemCount: ids.length,
                          itemBuilder: (context, index) {
                            final chatIds = ids[index];

                            final String fullName = chatIds.lastMessageSender;
                            final List<String> nameParts = fullName.split(' ');
                            final String firstName = nameParts[0];
                            final String format = chatIds.lastMessageTimeSent !=
                                        null &&
                                    chatIds.lastMessageType != 'chat'
                                ? chatIds.lastMessage
                                : chatIds.lastMessageTimeSent != null &&
                                        chatIds.lastMessageType == 'chat'
                                    ? '${firstName.substring(0, 1).toUpperCase()}${firstName.substring(1).toLowerCase()}: ${chatIds.lastMessage}'
                                    : '';
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    await ChatService()
                                        .updateUserLastMessageIdRead(
                                      chatIds.docID,
                                      ref.watch(setGlobalUniversityId),
                                      chatIds.lastMessageId,
                                      _auth.currentUser!.uid,
                                      true,
                                    );
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          settings: const RouteSettings(
                                              name: "/ChatOption"),
                                          builder: (context) {
                                            // Convert the Firebase Timestamp to a DateTime object
                                            DateTime dateTime =
                                                chatIds.timestamp.toDate();

                                            // Format the DateTime object into a string in "Month Day, Year" format
                                            String formattedDate =
                                                DateFormat.yMMMMd()
                                                    .format(dateTime);

                                            return ChatPage(
                                              groupChatId:
                                                  chatIds.docID.toString(),
                                              title: chatIds.studyGroupTitle,
                                              creator: chatIds.creatorId,
                                              desc:
                                                  chatIds.studyGroupDescription,
                                              dateCreated: formattedDate,
                                              courseCode:
                                                  chatIds.studyGroupCourseName,
                                              courseTitle: chatIds.courseTitle,
                                              members: chatIds.membersId,
                                              institutionId: ref
                                                  .watch(setGlobalUniversityId),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                      right: 15,
                                    ),
                                    height: 100,
                                    decoration: chatIds
                                                .members![
                                                    _auth.currentUser!.uid]!
                                                .lastMessageIdRead ==
                                            chatIds.lastMessageId
                                        ? BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                          )
                                        : BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            if (chatIds.membersRequestId
                                                    .isNotEmpty &&
                                                _auth.currentUser!.uid ==
                                                    chatIds.creatorId)
                                              Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer,
                                                  radius: 30,
                                                ),
                                              ),
                                            chatIds.groupChatImage != ''
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(chatIds
                                                            .groupChatImage!),
                                                    radius: 30,
                                                  )
                                                : Center(
                                                    child: ImagePlaceholder(
                                                      height: 70,
                                                      width: 70,
                                                      radius: 30,
                                                      title: chatIds
                                                          .studyGroupCourseName,
                                                      subtitle: "Study Group",
                                                      titleFontSize: 8,
                                                      subtitleFontSize: 6,
                                                      color: chatIds
                                                                  .members![_auth
                                                                      .currentUser!
                                                                      .uid]!
                                                                  .lastMessageIdRead ==
                                                              chatIds
                                                                  .lastMessageId
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondary
                                                          : Colors.white,
                                                      textColor: chatIds
                                                                  .members![_auth
                                                                      .currentUser!
                                                                      .uid]!
                                                                  .lastMessageIdRead !=
                                                              chatIds
                                                                  .lastMessageId
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .inversePrimary
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                    ),
                                                  )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                chatIds.studyGroupTitle,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              chatIds.lastMessageTimeSent !=
                                                      null
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          format,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .inversePrimary,
                                                                fontSize: 12),
                                                            DateFormat(
                                                                    'hh:mm a')
                                                                .format(
                                                              chatIds
                                                                  .lastMessageTimeSent!
                                                                  .toDate(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      chatIds
                                                          .studyGroupDescription,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.chevron_right,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Text('Error: $error'),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: StudyGroupChatLoading(),
                      );
                    },
                  );
                },
              ),
            );
          }
        });
  }
}
