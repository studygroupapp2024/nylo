import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nylo/components/buttons/send_button.dart';
import 'package:nylo/components/containers/chat_bubble.dart';
import 'package:nylo/components/skeletons/skeleton.dart';
import 'package:nylo/components/textfields/chat_textfield.dart';
import 'package:nylo/pages/chat/chat_info.dart';
import 'package:nylo/pages/chat/special_message.dart';
import 'package:nylo/pages/home/tutor/paginations/chat_pod.dart';
import 'package:nylo/repositories/chat_repo.dart';
import 'package:nylo/structure/models/chat_model.dart';
import 'package:nylo/structure/providers/chat_provider.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/storage_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends HookConsumerWidget {
  final String groupChatId;
  final String title;
  final String creator;
  final String desc;
  final String dateCreated;
  final String courseCode;
  final String courseTitle;
  final List<dynamic> members;
  final String institutionId;

  ChatPage({
    super.key,
    required this.groupChatId,
    required this.title,
    required this.creator,
    required this.desc,
    required this.dateCreated,
    required this.courseCode,
    required this.courseTitle,
    required this.members,
    required this.institutionId,
  });

  final TextEditingController _messageController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final ChatRepository _chatRepository = ChatRepository();
  final ScrollController listScrollController = ScrollController();
  late final Stream<dynamic> groupChats;

  Stream<dynamic> _requestChats(
      String groupChatId, String institutionId, bool isGroupChat) {
    groupChats = _chatRepository.listenToChatsRealTime(
      groupChatId,
      institutionId,
      true,
    );
    return groupChats;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRequesting = ref.watch(isRequestingProvider);

    useEffect(
      () {
        listScrollController.addListener(() => scrollListener(context, ref));
        return () {
          listScrollController
              .removeListener(() => scrollListener(context, ref));
        };
      },
      [],
    );

    useEffect(() {
      _requestChats(groupChatId, institutionId, true);
      return null;
    }, []);

    final groupChatMembers = ref.watch(
      groupChatMembersProvider(groupChatId),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            title,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: "/ChatPage"),
                    builder: (context) => ChatInfo(
                      groupChatId: groupChatId,
                      creator: creator,
                      groupChatTitle: title,
                      groupChatDescription: desc,
                      dateCreated: dateCreated,
                      courseCode: courseCode,
                      courseTitle: courseTitle,
                      members: members,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.info_outline,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Column(
            children: [
              Flexible(
                child: StreamBuilder(
                  stream: groupChats,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                          reverse: true,
                          controller: listScrollController,
                          itemCount:
                              snapshot.data!.length + (isRequesting ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == snapshot.data!.length) {
                              // This is the last item, and we're fetching more
                              if (isRequesting) {
                                // Display a loading indicator
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                // This is the end of the list, and no more items are being fetched
                                return const SizedBox
                                    .shrink(); // Or you can return null
                              }
                            }
                            final MessageModel messageInfo =
                                snapshot.data![index];

                            final userInfo = ref.watch(
                              userInfoProvider(
                                messageInfo.senderId,
                              ),
                            );
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: messageInfo.senderId ==
                                            _firebaseAuth.currentUser!.uid &&
                                        messageInfo.type == "chat"
                                    ? MainAxisAlignment.end
                                    : messageInfo.senderId ==
                                                _firebaseAuth
                                                    .currentUser!.uid &&
                                            messageInfo.type == "special"
                                        ? MainAxisAlignment.end
                                        : messageInfo.senderId !=
                                                    _firebaseAuth
                                                        .currentUser!.uid &&
                                                messageInfo.type == "chat"
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (messageInfo.senderId !=
                                              _firebaseAuth.currentUser!.uid &&
                                          messageInfo.type == "chat" ||
                                      messageInfo.senderId !=
                                              _firebaseAuth.currentUser!.uid &&
                                          messageInfo.type == "special")
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Stack(
                                        children: [
                                          // change image
                                          userInfo.when(
                                            data: (data) {
                                              return CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                  data.imageUrl,
                                                ),
                                              );
                                            },
                                            error: (error, stackTrace) => Text(
                                              error.toString(),
                                            ),
                                            loading: () {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[400]!,
                                                highlightColor:
                                                    Colors.grey[300]!,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.black
                                                      .withOpacity(.15),
                                                  radius: 20,
                                                ),
                                              );
                                            },
                                          ),

                                          Container(
                                            height: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                          )
                                        ],
                                      ),
                                    ),
                                  Column(
                                    crossAxisAlignment: (messageInfo.senderId ==
                                            _firebaseAuth.currentUser!.uid)
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      if (messageInfo.senderId !=
                                              _firebaseAuth.currentUser!.uid &&
                                          messageInfo.type == "chat")
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            top: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              userInfo.when(
                                                data: (data) {
                                                  final formattedName =
                                                      formatName(data.name);
                                                  return Text(
                                                    formattedName,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  );
                                                },
                                                error: (error, stackTrace) =>
                                                    Text(
                                                  error.toString(),
                                                ),
                                                loading: () {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[400]!,
                                                    highlightColor:
                                                        Colors.grey[300]!,
                                                    child: const Skeleton(
                                                      height: 15,
                                                      width: 20,
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ChatBubble(
                                        fileName: messageInfo.filename ?? '',
                                        downloadUrl:
                                            messageInfo.downloadUrl ?? '',
                                        type: messageInfo.type,
                                        time: DateFormat('MM/dd ' 'hh:mm a')
                                            .format(
                                          messageInfo.timestamp.toDate(),
                                        ),
                                        category: messageInfo.category!,
                                        textAlign:
                                            messageInfo.type == "announcement"
                                                ? TextAlign.center
                                                : TextAlign.start,
                                        fontSize:
                                            messageInfo.type == "announcement"
                                                ? 12
                                                : 16,
                                        borderRadius: messageInfo.senderId ==
                                                _firebaseAuth.currentUser!.uid
                                            ? const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight: Radius.circular(5),
                                              )
                                            : const BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(20),
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                              ),
                                        alignment: messageInfo.senderId ==
                                                    _firebaseAuth
                                                        .currentUser!.uid &&
                                                messageInfo.type == "chat"
                                            ? Alignment.centerRight
                                            : messageInfo.senderId !=
                                                        _firebaseAuth
                                                            .currentUser!.uid &&
                                                    messageInfo.type == "chat"
                                                ? Alignment.centerLeft
                                                : Alignment.center,
                                        senderMessage:
                                            messageInfo.type == "special"
                                                ? messageInfo.message +
                                                    messageInfo.downloadUrl
                                                        .toString()
                                                : messageInfo.message,
                                        backgroundColor: messageInfo.senderId ==
                                                        _firebaseAuth
                                                            .currentUser!.uid &&
                                                    messageInfo.type ==
                                                        "chat" ||
                                                messageInfo.senderId ==
                                                        _firebaseAuth
                                                            .currentUser!.uid &&
                                                    messageInfo.type ==
                                                        "special"
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiaryContainer
                                            : messageInfo.senderId !=
                                                        _firebaseAuth
                                                            .currentUser!.uid &&
                                                    messageInfo.type == "chat"
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                        textColor: messageInfo.senderId ==
                                                        _firebaseAuth
                                                            .currentUser!.uid &&
                                                    messageInfo.type ==
                                                        "chat" ||
                                                messageInfo.senderId ==
                                                        _firebaseAuth
                                                            .currentUser!.uid &&
                                                    messageInfo.type ==
                                                        "special"
                                            ? Theme.of(context)
                                                .colorScheme
                                                .background
                                            : messageInfo.senderId !=
                                                        _firebaseAuth
                                                            .currentUser!.uid &&
                                                    messageInfo.type == "chat"
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                      ),
                                      messageInfo.senderId !=
                                              _firebaseAuth.currentUser!.uid
                                          ? const SizedBox(
                                              height: 6,
                                            )
                                          : const SizedBox(
                                              height: 3,
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              if (members.contains(_firebaseAuth.currentUser!.uid))
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendSpecialMessage(
                                groupChatId: groupChatId,
                                groupChatTitle: title,
                              ),
                            ),
                          );

                          ref.watch(documentTypeProvider.notifier).state = '';
                          ref.read(pathNameProvider.notifier).state = '';
                          ref.read(fileNameProvider.notifier).state = '';
                        },
                        icon: const Icon(Icons.add_circle_outline_outlined),
                      ),
                      Expanded(
                        child: ChatTextField(
                          hintText: "Enter a message",
                          obscureText: false,
                          controller: _messageController,
                        ),
                      ),
                      groupChatMembers.when(data: (membersList) {
                        return SendButton(
                          onPressed: () async {
                            if (_messageController.text.isNotEmpty) {
                              ref
                                  .read(isLoadingProvider.notifier)
                                  .update((state) => true);

                              final sendMessage =
                                  await ref.read(chatProvider).sendMessage(
                                        groupChatId,
                                        _messageController.text,
                                        "chat",
                                        "",
                                        ref.watch(setGlobalUniversityId),
                                        title,
                                        "",
                                        "",
                                        true,
                                      );
                              ref
                                  .read(isLoadingProvider.notifier)
                                  .update((state) => false);

                              if (sendMessage) {
                                _messageController.clear();
                              }
                            }
                          },
                        );
                      }, error: (error, stackTrace) {
                        return Center(
                          child: Text('Error: $error'),
                        );
                      }, loading: () {
                        return const Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.send),
                        );
                      }),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void scrollListener(BuildContext context, WidgetRef ref) async {
    final isRequestingNotifier = ref.read(isRequestingProvider.notifier);
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      isRequestingNotifier.update((state) => true);

      _chatRepository.requestMoreData(
        groupChatId,
        institutionId,
        true,
      );

      await Future.delayed(const Duration(seconds: 2));
      isRequestingNotifier.update((state) => false);
    }
  }
}

String formatName(String name) {
  final String fullName = name;
  final List<String> nameParts = fullName.split(' ');
  final String firstName = nameParts[0];
  final String format = firstName.substring(0, 1).toUpperCase() +
      firstName.substring(1).toLowerCase();

  return format;
}
