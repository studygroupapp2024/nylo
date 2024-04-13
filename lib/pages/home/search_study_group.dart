import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/study_group_container.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/pages/home/create_study_group.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class FindStudyGroup extends ConsumerWidget {
  FindStudyGroup({super.key});

  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // void requestToJoin(String chatId, groupTitle) async {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Study Groups",
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  ref
                      .read(searchQueryLengthProvider.notifier)
                      .update((state) => value.length);
                  ref
                      .read(searchQueryProvider.notifier)
                      .update((state) => value);
                },
                obscureText: false,
                controller: _controller,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
              ),
            ),
            if (ref.watch(searchQueryLengthProvider) < 3)
              const Expanded(
                child: Center(
                  child: Text(
                    "Search study group by subject code and title",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (ref.watch(searchQueryLengthProvider) >= 3)
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final multipleGroupChatProvider = ref.watch(
                      selectedGroupChatInformationProvider(
                          _auth.currentUser!.uid),
                    );
                    return multipleGroupChatProvider.when(
                      data: (groupchats) {
                        if (groupchats.isEmpty) {
                          return NoContent(
                              icon:
                                  'assets/icons/book-shelf-books-education-learning-school-study_svgrepo.com.svg',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateStudyGroup(),
                                  ),
                                );
                              },
                              description:
                                  "There is no study group available for now. Do you want to lead one?",
                              buttonText: "Create Study Group");
                        } else {
                          return ListView.builder(
                            itemCount: groupchats.length,
                            itemBuilder: (context, index) {
                              final groupChats = groupchats[index];
                              final membersRequestList = groupChats
                                  .membersRequestId
                                  .map((e) => e as String)
                                  .toList();

                              return StudyGroupContainer(
                                onTap: membersRequestList
                                        .contains(_auth.currentUser!.uid)
                                    ? null
                                    : () async {
                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = true;
                                        await ref
                                            .read(
                                                groupChatMemberRequestProvider)
                                            .requestToJoin(
                                              groupChats.docID.toString(),
                                              groupChats.creatorId,
                                              groupChats.studyGroupTitle,
                                              ref.watch(setGlobalUniversityId),
                                              _auth.currentUser!.uid,
                                            );

                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = false;
                                      },
                                title: groupChats.studyGroupTitle,
                                desc: groupChats.studyGroupDescription,
                                members: groupChats.membersId.length.toString(),
                                image: groupChats.groupChatImage,
                                identifier: membersRequestList
                                        .contains(_auth.currentUser!.uid)
                                    ? "Pending Application"
                                    : "Join",
                                subjectCode: groupChats.studyGroupCourseName,
                                subjectTitle: groupChats.courseTitle,
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
      ),
    );
  }
}
