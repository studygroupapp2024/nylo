import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/paginations/test_pagination.dart';
import 'package:nylo/structure/models/chat_model.dart';

final isRequestingProvider = StateProvider<bool>((ref) => false);

class ChatView extends HookConsumerWidget {
  final String chatId;
  final String institutionId;
  ChatView({
    super.key,
    required this.chatId,
    required this.institutionId,
  });

  final FireStoreRepository fireStoreRepository = FireStoreRepository();
  final ScrollController listScrollController = ScrollController();
  late final Stream<dynamic> subjects;

  Stream<dynamic> _requestChats(String chatId, String institutionId) {
    subjects = fireStoreRepository.listenToChatsRealTime(chatId, institutionId);
    return subjects;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      _requestChats(chatId, institutionId);
      return null;
    }, []);

    final isRequesting = ref.watch(isRequestingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: subjects,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    reverse: true,
                    controller: listScrollController,
                    itemCount: snapshot.data!.length + (isRequesting ? 1 : 0),
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
                      final MessageModel chat = snapshot.data![index];
                      return IntrinsicHeight(
                        child: Container(
                          child: ListTile(
                            title: Text(chat.message),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void scrollListener(BuildContext context, WidgetRef ref) async {
    final isRequestingNotifier = ref.read(isRequestingProvider.notifier);
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      isRequestingNotifier.update((state) => true);

      fireStoreRepository.requestMoreData(chatId, institutionId);

      await Future.delayed(const Duration(seconds: 2));
      isRequestingNotifier.update((state) => false);
    }
  }
}
