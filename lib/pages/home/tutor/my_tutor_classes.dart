import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/pages/home/study_group/search_study_group.dart';
import 'package:nylo/pages/home/tutor/tutor_chat_page.dart';
import 'package:nylo/structure/models/direct_message_model.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class TutorClassses extends ConsumerWidget {
  TutorClassses({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTutorClass =
        ref.watch(tutorDirectMessages(_auth.currentUser!.uid));
    final userTuteeClass =
        ref.watch(tuteeDirectMessages(_auth.currentUser!.uid));
    final myTutor = ref.watch(myTutorProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connections"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(myTutorProvider.notifier).update((state) => true);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                      left: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: myTutor
                          ? Theme.of(context).colorScheme.tertiaryContainer
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.subject_outlined,
                          color: myTutor
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Tutors",
                          style: TextStyle(
                            color: myTutor
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(myTutorProvider.notifier).update((state) => false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: myTutor
                          ? null
                          : Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.done_all_rounded,
                          color: myTutor
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.background,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Tutee",
                          style: TextStyle(
                            color: myTutor
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final AsyncValue<List<DirectMessageModel>> connections;

                // Determine which function to call based on myTutor flag
                if (myTutor) {
                  connections =
                      ref.watch(tutorDirectMessages(_auth.currentUser!.uid));
                } else {
                  connections =
                      ref.watch(tuteeDirectMessages(_auth.currentUser!.uid));
                }
                return connections.when(
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
                                      chatIds.lastMessageType == 'chat' &&
                                      chatIds.proctorId ==
                                          _auth.currentUser!.uid
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
                          final subjectMatterInfo = ref.watch(
                            directMessageInfoProvider(
                              chatIds.classId,
                            ),
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

                                        return TutorChatPage(
                                          groupChatId: chatIds.chatId!,
                                          title:
                                              _auth.currentUser!.displayName!,
                                          creator: chatIds.proctorId,
                                          dateCreated: formattedDate,
                                          members: chatIds.membersId,
                                          classId: chatIds.classId,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: IntrinsicHeight(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: chatIds.lastMessage ==
                                              chatIds.membersId
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: IntrinsicHeight(
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
                                                                const EdgeInsets
                                                                    .all(5),
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
                                                    error:
                                                        (error, stackTrace) =>
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
                                                                const EdgeInsets
                                                                    .all(5),
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
                                                    error:
                                                        (error, stackTrace) =>
                                                            const Text("Error"),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
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
                                                              Courses(
                                                                  subjectMatterInfo),
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
                                                                                style: const TextStyle(fontSize: 13),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              )
                                                                            : Text(
                                                                                "You: $format",
                                                                                style: const TextStyle(fontSize: 13),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12),
                                                                            DateFormat('hh:mm a').format(
                                                                              chatIds.lastMessageTimeSent!.toDate(),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Text(
                                                                      chatIds
                                                                          .lastMessage,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                            ],
                                                          );
                                                        },
                                                        loading: () =>
                                                            const CircularProgressIndicator(),
                                                        error: (error,
                                                                stackTrace) =>
                                                            const Text(
                                                                "Error"));
                                                  } else {
                                                    return tuteeInfo.when(
                                                        data: (data) {
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Courses(
                                                                  subjectMatterInfo),
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
                                                                                style: const TextStyle(fontSize: 13),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              )
                                                                            : Text(
                                                                                "You: $format",
                                                                                style: const TextStyle(fontSize: 13),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12),
                                                                            DateFormat('hh:mm a').format(
                                                                              chatIds.lastMessageTimeSent!.toDate(),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Text(
                                                                      chatIds
                                                                          .lastMessage,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                            ],
                                                          );
                                                        },
                                                        loading: () =>
                                                            const CircularProgressIndicator(),
                                                        error: (error,
                                                                stackTrace) =>
                                                            const Text(
                                                                "Error"));
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
          ),
        ],
      ),
    );
  }

  Consumer Courses(AsyncValue<SubjectMatterModel> subjectMatterInfo) {
    return Consumer(
      builder: (context, ref, child) {
        return subjectMatterInfo.when(
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.className,
                  textAlign: TextAlign.start,
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
                                    style: const TextStyle(fontSize: 10),
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
        );
      },
    );
  }
}
