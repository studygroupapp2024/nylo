import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/pages/home/tutor/paginations/test_pagination.dart';
import 'package:nylo/structure/models/subject_model.dart';

final isRequestingProvider = StateProvider<bool>((ref) => false);

class ChatView extends HookConsumerWidget {
  ChatView({super.key});
  final FireStoreRepository fireStoreRepository = FireStoreRepository();
  final ScrollController listScrollController = ScrollController();

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
    final isRequesting = ref.watch(isRequestingProvider);
    return Scaffold(
      appBar: AppBar(
        title: isRequesting ? const Text("Loading...") : const Text("Chats"),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: fireStoreRepository.listenToChatsRealTime(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    controller: listScrollController,
                    itemCount: snapshot.data!.length + (isRequesting ? 1 : 0),
                    itemBuilder: (context, index) {
                      print(
                          "IS REQUESTING: $isRequesting, LENGTH: ${snapshot.data!.length}");

                      if (index == snapshot.data!.length) {
                        // This is the last item, and we're fetching more
                        if (isRequesting) {
                          // Display a loading indicator
                          return const Padding(
                            padding: EdgeInsets.all(5),
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
                      final SubjectModel chat = snapshot.data![index];
                      return IntrinsicHeight(
                        child: Container(
                          child: ListTile(
                            title: Text(chat.subject_title),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // if (isRequesting)
          //   const IntrinsicHeight(
          //     child: SizedBox(
          //       height: 50,
          //       child: Center(
          //         child: CircularProgressIndicator(),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  void scrollListener(BuildContext context, WidgetRef ref) async {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      ref.read(isRequestingProvider.notifier).state = true;
      print("IS REQUESTING 1: ${ref.watch(isRequestingProvider)}");
      fireStoreRepository.requestMoreData();
      print("Fetching more data...");
      await Future.delayed(const Duration(seconds: 2));
      ref.read(isRequestingProvider.notifier).state = false;
      print("IS REQUESTING 2: ${ref.watch(isRequestingProvider)}");
    }
  }
}
