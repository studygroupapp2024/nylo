import 'package:flutter/material.dart';
import 'package:nylo/pages/home/tutor/paginations/test_pagination.dart';
import 'package:nylo/structure/models/subject_model.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FireStoreRepository _fireStoreRepository = FireStoreRepository();
  final ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _listScrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: _fireStoreRepository.listenToChatsRealTime(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    controller: _listScrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
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
        ],
      ),
    );
  }

  void _scrollListener() {
    if (_listScrollController.offset >=
            _listScrollController.position.maxScrollExtent &&
        !_listScrollController.position.outOfRange) {
      _fireStoreRepository.requestMoreData();
    }
  }
}
