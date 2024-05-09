import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nylo/structure/models/chat_model.dart';

class TutorChatRepository {
  final CollectionReference _chatCollectionReference =
      FirebaseFirestore.instance.collection('institution');

  final StreamController<List<MessageModel>> _chatController =
      StreamController<List<MessageModel>>.broadcast();

  final List<List<MessageModel>> _allPagedResults = [];

  static const int chatLimit = 15;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream listenToChatsRealTime(String chatId, String institutionId) {
    _requestChats(chatId, institutionId);
    return _chatController.stream;
  }

  void _requestChats(
    String chatId,
    String institutionId,
  ) async {
    print("chatId: $chatId, institutionId: $institutionId");
    var pagechatQuery = _chatCollectionReference
        .doc(institutionId)
        .collection("direct_messages")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(chatLimit);

    if (_lastDocument != null) {
      pagechatQuery = pagechatQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) return;

    var currentRequestIndex = _allPagedResults.length;

    pagechatQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalChats = snapshot.docs
              .map((snapshot) => MessageModel.fromMap(snapshot.data()))
              .toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalChats;
          } else {
            _allPagedResults.add(generalChats);
          }

          var allChats = _allPagedResults.fold<List<MessageModel>>(
              [], // Using list literal to create an empty list
              (initialValue, pageItems) => initialValue..addAll(pageItems));
          _chatController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalChats.length == chatLimit;
        }
      },
    );
  }

  void requestMoreData(chatId, institutionId) =>
      _requestChats(chatId, institutionId);
}
