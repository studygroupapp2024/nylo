import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/pages/home/study_group/search_study_group.dart';
import 'package:nylo/pages/home/tutor/tutor_chat_page.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class TutorClassses extends ConsumerWidget {
  TutorClassses({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTutorClass =
        ref.watch(userDirectMessages(_auth.currentUser!.uid));

    print("Tutor Class: $userTutorClass");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutors"),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return userTutorClass.when(
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
                        "It seems like you have no tutors groups yet. Do you want to find one?",
                    buttonText: "Find Study Group");
              } else {
                print("IDs: ${ids.map((e) => e.chatId).toList()}");
                return ListView.builder(
                  itemCount: ids.length,
                  itemBuilder: (context, index) {
                    final chatIds = ids[index];

                    final String fullName = chatIds.lastMessageSender;
                    final List<String> nameParts = fullName.split(' ');
                    final String firstName = nameParts[0];
                    final String format = chatIds.lastMessageTimeSent != null &&
                            chatIds.lastMessageType != 'chat'
                        ? chatIds.lastMessage
                        : chatIds.lastMessageTimeSent != null &&
                                chatIds.lastMessageType == 'chat' &&
                                chatIds.proctorId == _auth.currentUser!.uid
                            ? chatIds.lastMessage
                            : chatIds.lastMessageTimeSent != null &&
                                    chatIds.lastMessageType == 'chat' &&
                                    chatIds.lastMessageSender !=
                                        _auth.currentUser!.uid
                                ? chatIds.lastMessage
                                : '';
                    final userInfo = ref.watch(
                      userInfoProvider(chatIds.proctorId),
                    );
                    final tuteeInfo = ref.watch(
                      userInfoProvider(chatIds.tuteeId),
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings:
                                    const RouteSettings(name: "/ChatOption"),
                                builder: (context) {
                                  // Convert the Firebase Timestamp to a DateTime object
                                  DateTime dateTime =
                                      chatIds.timestamp.toDate();

                                  // Format the DateTime object into a string in "Month Day, Year" format
                                  String formattedDate =
                                      DateFormat.yMMMMd().format(dateTime);

                                  return TutorChatPage(
                                    groupChatId: chatIds.chatId!,
                                    title: _auth.currentUser!.displayName!,
                                    creator: chatIds.proctorId,
                                    dateCreated: formattedDate,
                                    members: chatIds.membersId,
                                    classId: chatIds.classId,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 100,
                            decoration: BoxDecoration(
                              color: chatIds.lastMessage == chatIds.membersId
                                  ? Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Row(
                              children: [
                                IntrinsicHeight(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      if (chatIds.proctorId !=
                                          _auth.currentUser!.uid) {
                                        return userInfo.when(
                                          data: (data) {
                                            return Row(
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 70,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      data.imageUrl,
                                                    ),
                                                    radius: 30,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          loading: () =>
                                              const CircularProgressIndicator(),
                                          error: (error, stackTrace) =>
                                              const Text("Error"),
                                        );
                                      } else {
                                        return tuteeInfo.when(
                                          data: (data) {
                                            return Row(
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 70,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      data.imageUrl,
                                                    ),
                                                    radius: 30,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          loading: () =>
                                              const CircularProgressIndicator(),
                                          error: (error, stackTrace) =>
                                              const Text("Error"),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Consumer(
                                        builder: (context, ref, child) {
                                          if (chatIds.proctorId !=
                                              _auth.currentUser!.uid) {
                                            return userInfo.when(
                                                data: (data) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                                chatIds.lastMessageSender ==
                                                                        data.name
                                                                    ? Text(
                                                                        "${firstName.substring(0, 1).toUpperCase()}${firstName.substring(1).toLowerCase()}: $format",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )
                                                                    : Text(
                                                                        "You: $format",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                        fontSize:
                                                                            12),
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
                                                                  .lastMessage,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                    ],
                                                  );
                                                },
                                                loading: () =>
                                                    const CircularProgressIndicator(),
                                                error: (error, stackTrace) =>
                                                    const Text("Error"));
                                          } else {
                                            return tuteeInfo.when(
                                                data: (data) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                                chatIds.lastMessageSender ==
                                                                        data.name
                                                                    ? Text(
                                                                        "${firstName.substring(0, 1).toUpperCase()}${firstName.substring(1).toLowerCase()}: $format",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )
                                                                    : Text(
                                                                        "You: $format",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                        fontSize:
                                                                            12),
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
                                                                  .lastMessage,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                    ],
                                                  );
                                                },
                                                loading: () =>
                                                    const CircularProgressIndicator(),
                                                error: (error, stackTrace) =>
                                                    const Text("Error"));
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
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
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
