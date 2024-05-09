// import 'package:flutter/material.dart';
// import 'package:nylo/pages/home/tutor/paginations/test_pagination.dart';
// import 'package:nylo/structure/models/subject_model.dart';

// class ChatViews extends StatefulWidget {
//   const ChatViews({super.key});

//   @override
//   State<ChatView> createState() => _ChatViewState();
// }

// class _ChatViewState extends State<ChatView> {
//   final FireStoreRepository _fireStoreRepository = FireStoreRepository();
//   final ScrollController _listScrollController = ScrollController();
//   bool isFetchingMore = false;
//   @override
//   void initState() {
//     super.initState();

//     _listScrollController.addListener(_scrollListener);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: isFetchingMore ? const Text("Loading...") : const Text("Chats"),
//       ),
//       body: Column(
//         children: [
//           Flexible(
//             child: StreamBuilder(
//               stream: _fireStoreRepository.listenToChatsRealTime(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else {
//                   return ListView.builder(
//                     controller: _listScrollController,
//                     itemCount: snapshot.data!.length + (isFetchingMore ? 1 : 0),
//                     itemBuilder: (context, index) {
//                       if (index == snapshot.data!.length) {
//                         // This is the last item, and we're fetching more
//                         if (isFetchingMore) {
//                           // Display a loading indicator
//                           return const Padding(
//                             padding: EdgeInsets.all(5),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           );
//                         } else {
//                           // This is the end of the list, and no more items are being fetched
//                           return const SizedBox
//                               .shrink(); // Or you can return null
//                         }
//                       }
//                       final SubjectModel chat = snapshot.data![index];
//                       return IntrinsicHeight(
//                         child: Container(
//                           child: ListTile(
//                             title: Text(chat.subject_title),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _scrollListener() {
//     if (_listScrollController.offset >=
//             _listScrollController.position.maxScrollExtent &&
//         !_listScrollController.position.outOfRange) {
//       setState(() {
//         isFetchingMore =
//             true; // Set isFetchingMore to true before fetching more data
//       });
//       print("IS FETCHING MORE: $isFetchingMore");
//       _fireStoreRepository.requestMoreData();
//       print("Fetching more data...");

//       setState(() {
//         isFetchingMore =
//             false; // Set isFetchingMore to true before fetching more data
//       });
//     }
//   }
// }
