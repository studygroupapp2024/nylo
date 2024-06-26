import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/no_data_holder.dart';
import 'package:nylo/pages/home/tutor/components/chips/subject_chip.dart';
import 'package:nylo/pages/home/tutor/register_as_tutor.dart';
import 'package:nylo/pages/home/tutor/tutor_chat_page.dart';
import 'package:nylo/structure/models/selected_courses_to_teach_model.dart';
import 'package:nylo/structure/models/subject_matter_model.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/direct_message_provider.dart';
import 'package:nylo/structure/providers/register_as_tutor_providers.dart';
import 'package:nylo/structure/providers/subject_matter_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';
import 'package:shimmer/shimmer.dart';

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
            const SizedBox(
              height: 10,
            ),
            if (ref.watch(findTutorSearchQueryLengthProvider) < 3)
              const Expanded(
                child: Center(
                  child: Text(
                    "Find tutors by subject or name",
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
                        if (groupchats.isEmpty) {
                          return NoContent(
                              icon:
                                  'assets/icons/book-shelf-books-education-learning-school-study_svgrepo.com.svg',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterAsTutorPage(),
                                  ),
                                );
                              },
                              description:
                                  "There are no classes on the aforementioned course. Do you want to lead one?",
                              buttonText: "Create Class");
                        } else {
                          return ListView.builder(
                            itemCount: groupchats.length,
                            itemBuilder: (context, index) {
                              final groupChats = groupchats[index];

                              return InkWell(
                                onTap: () {
                                  ref
                                      .read(selectedCoursesToTeachProvider
                                          .notifier)
                                      .clear();
                                  for (final item
                                      in groupChats.subjects!.entries) {
                                    final subjectId = item.key;
                                    final subject = item.value;

                                    ref
                                        .read(selectedCoursesToTeachProvider
                                            .notifier)
                                        .add(
                                          SelectedCoursesToTeachModel(
                                            subjectId: subjectId,
                                            subjectTitle:
                                                subject.subjectTitle, //
                                            subjectCode: subject.subjectCode,
                                          ),
                                        );
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: IntrinsicHeight(
                                          child: Container(
                                            margin: const EdgeInsets.all(
                                              20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Consumer(
                                                  builder:
                                                      (context, ref, child) {
                                                    final user = ref.watch(
                                                      userInfoProvider(
                                                          groupChats.proctorId),
                                                    );

                                                    return user.when(
                                                      data: (userData) {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 40,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                    userData.imageUrl ??
                                                                        _auth
                                                                            .currentUser!
                                                                            .photoURL!,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      userData.name ??
                                                                          _auth
                                                                              .currentUser!
                                                                              .displayName!,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "Proctor",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              groupChats
                                                                  .className,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 24,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(groupChats
                                                                .description),
                                                          ],
                                                        );
                                                      },
                                                      error:
                                                          (error, stackTrace) {
                                                        return Center(
                                                          child: Text(
                                                              'Error: $error'),
                                                        );
                                                      },
                                                      loading: () {
                                                        return Center(
                                                          child: Shimmer
                                                              .fromColors(
                                                            baseColor: Colors
                                                                .grey[400]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[300]!,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          .15),
                                                              radius: 40,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SubjectChip(
                                                    subjects:
                                                        groupChats.subjects!),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                RoundedButtonWithProgress(
                                                  text: "Connect",
                                                  onTap: () async {
                                                    ref
                                                        .read(isLoadingProvider
                                                            .notifier)
                                                        .state = true;
                                                    // create a Direct Message
                                                    final getData = await ref
                                                        .watch(
                                                            directMessageProvider)
                                                        .addDirectMessage(
                                                          ref.watch(
                                                              setGlobalUniversityId),
                                                          groupChats.proctorId,
                                                          groupChats.classId!,
                                                          ref.watch(
                                                              selectedCoursesToTeachProvider),
                                                          groupChats.className,
                                                          groupChats
                                                              .description,
                                                        );

                                                    if (getData['isSuccess']) {
                                                      if (context.mounted) {
                                                        Navigator.pop(context);

                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TutorChatPage(
                                                              groupChatId: getData[
                                                                  'directMessageId'],
                                                              title: getData[
                                                                  'title'],
                                                              creator: getData[
                                                                  'creator'],
                                                              dateCreated: getData[
                                                                  'dateCreated'],
                                                              members: getData[
                                                                  'membersId'],
                                                              classId: getData[
                                                                  'classId'],
                                                              institutionId:
                                                                  ref.watch(
                                                                      setGlobalUniversityId),
                                                            ),
                                                          ),
                                                        );
                                                        ref
                                                            .read(
                                                                isLoadingProvider
                                                                    .notifier)
                                                            .state = false;
                                                      }
                                                    }
                                                  },
                                                  margin:
                                                      const EdgeInsets.all(0),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer,
                                                  textcolor: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: IntrinsicHeight(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: ProctorImage(groupChats)),
                                        Expanded(
                                          child: Row(
                                            children: [
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
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: SubjectChip(
                                                      subjects:
                                                          groupChats.subjects!,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
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

  Consumer ProctorImage(SubjectMatterModel groupChats) {
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(
          userInfoProvider(groupChats.proctorId),
        );

        return user.when(
          data: (userData) {
            return Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  userData.imageUrl ?? _auth.currentUser!.photoURL!,
                ),
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
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}
