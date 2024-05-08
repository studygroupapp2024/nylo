import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nylo/structure/models/subject_model.dart';

class FireStoreRepository {
  final CollectionReference _chatCollectionReference = FirebaseFirestore
      .instance
      .collection('institution')
      .doc("EZBnoEJUgUd4dZU8aWRD")
      .collection('subjects');

  final StreamController<List<SubjectModel>> _chatController =
      StreamController<List<SubjectModel>>.broadcast();

  final List<List<SubjectModel>> _allPagedResults = [];

  static const int chatLimit = 15;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream listenToChatsRealTime() {
    _requestChats();
    return _chatController.stream;
  }

  void _requestChats() {
    var pagechatQuery = _chatCollectionReference.limit(chatLimit);

    if (_lastDocument != null) {
      pagechatQuery = pagechatQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) return;

    var currentRequestIndex = _allPagedResults.length;

    pagechatQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalChats = snapshot.docs
              .map((snapshot) =>
                  SubjectModel.fromMap(snapshot.data() as Map<String, dynamic>))
              .toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalChats;
          } else {
            _allPagedResults.add(generalChats);
          }

          var allChats = _allPagedResults.fold<List<SubjectModel>>(
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

  void requestMoreData() => _requestChats();
}
