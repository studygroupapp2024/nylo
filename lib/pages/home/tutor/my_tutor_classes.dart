import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nylo/components/chats/tutor_chat_container.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/components/skeletons/my_tutor_chat_loading.dart';
import 'package:nylo/pages/home/study_group/search_study_group.dart';
import 'package:nylo/pages/home/tutor/register_as_tutor.dart';
import 'package:nylo/pages/home/tutor/tutor_chat_page.dart';
import 'package:nylo/structure/models/direct_message_model.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/services/chat_services.dart';

class TutorClassses extends ConsumerWidget {
  TutorClassses({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                      if (myTutor) {
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
                        return NoContent(
                            icon: 'assets/icons/search-phone_svgrepo.com.svg',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterAsTutorPage(),
                                ),
                              );
                            },
                            description:
                                "You do not have any student to tutor yet.",
                            buttonText: 'Create Tutor Class');
                      }
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

                          return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                left: 10,
                                right: 10,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  await ChatService()
                                      .updateUserLastMessageIdRead(
                                    chatIds.chatId!,
                                    ref.watch(setGlobalUniversityId),
                                    chatIds.lastMessageId!,
                                    _auth.currentUser!.uid,
                                    false,
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

                                          return TutorChatPage(
                                            groupChatId: chatIds.chatId!,
                                            title:
                                                _auth.currentUser!.displayName!,
                                            creator: chatIds.proctorId,
                                            dateCreated: formattedDate,
                                            members: chatIds.membersId,
                                            classId: chatIds.classId,
                                            institutionId: ref
                                                .watch(setGlobalUniversityId),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                child: IntrinsicHeight(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: chatIds.lastMessageId !=
                                              chatIds
                                                  .members![
                                                      _auth.currentUser!.uid]!
                                                  .lastMessageIdRead
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
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
                                              chatIds.proctorId !=
                                                      _auth.currentUser!.uid
                                                  ? TutorChatContainer(
                                                      chatIds: chatIds,
                                                      firstName: firstName,
                                                      format: format,
                                                      image: chatIds
                                                          .members![chatIds
                                                              .proctorId]!
                                                          .imageUrl,
                                                      name: chatIds
                                                          .members![chatIds
                                                              .proctorId]!
                                                          .name,
                                                    )
                                                  : TutorChatContainer(
                                                      chatIds: chatIds,
                                                      firstName: firstName,
                                                      format: format,
                                                      image: chatIds
                                                          .members![
                                                              chatIds.tuteeId]!
                                                          .imageUrl,
                                                      name: chatIds
                                                          .members![
                                                              chatIds.tuteeId]!
                                                          .name,
                                                    )
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
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
                    return const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: TutorChatLoading(),
                      ),
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
}
