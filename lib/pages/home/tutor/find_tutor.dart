import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/pages/home/study_group/create_study_group.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class FindTutor extends ConsumerWidget {
  FindTutor({super.key});

  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Tutors"),
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
                      .read(findTutorSearchQueryLengthProvider.notifier)
                      .update((state) => value.length);
                  print("VALUE: $value");
                  print("Value: ${ref.watch(findTutorSearchQueryProvider)}");
                  ref
                      .read(findTutorSearchQueryProvider.notifier)
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
            if (ref.watch(findTutorSearchQueryLengthProvider) < 3)
              const Expanded(
                child: Center(
                  child: Text(
                    "Search study group by subject code and title",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (ref.watch(findTutorSearchQueryLengthProvider) >= 3)
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final multipleGroupChatProvider = ref.watch(
                      selectedClassInformationProvider(_auth.currentUser!.uid),
                    );
                    return multipleGroupChatProvider.when(
                      data: (groupchats) {
                        print("groupchats: ${groupchats.length}");
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
                              print("groupChats: $groupChats");
                              return IntrinsicHeight(
                                child: Container(
                                  margin: const EdgeInsets.all(20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Consumer(
                                        builder: (context, ref, child) {
                                          final user = ref.watch(
                                            userInfoProvider(
                                                groupChats.proctorId),
                                          );

                                          return user.when(
                                            data: (userData) {
                                              return CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  userData.imageUrl,
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
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            groupChats.className,
                                          ),
                                          Wrap(
                                            spacing: 10,
                                            children: groupChats.courseId
                                                .map(
                                                  (e) => Consumer(
                                                    builder:
                                                        (context, ref, child) {
                                                      final course = ref.watch(
                                                          getSubjectInfo(e));

                                                      return course.when(
                                                        data: (data) {
                                                          return Chip(
                                                            label: Text(
                                                              data.subject_code,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10),
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                            stackTrace) {
                                                          return Center(
                                                            child: Text(
                                                                'Error: $error'),
                                                          );
                                                        },
                                                        loading: () {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                          IntrinsicHeight(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    // create a Direct Message
                                                    await ref
                                                        .watch(
                                                            directMessageProvider)
                                                        .addDirectMessage(
                                                          ref.watch(
                                                              setGlobalUniversityId),
                                                          groupChats.proctorId,
                                                          groupChats.classId!,
                                                        );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Connect",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiaryContainer,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
      ),
    );
  }
}
