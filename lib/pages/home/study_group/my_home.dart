import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/category_container.dart';
import 'package:nylo/components/skeletons/home_loading.dart';
import 'package:nylo/components/skeletons/skeleton.dart';
import 'package:nylo/pages/home/study_group/my_profile.dart';
import 'package:nylo/structure/auth/login_or_register.dart';
import 'package:nylo/structure/models/category_model.dart';
import 'package:nylo/structure/providers/auth_provider.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/homepage_providers.dart';
import 'package:nylo/structure/providers/user_provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isMyGroup = ref.watch(myGroup);
    return authState.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (data) {
        if (data == null) {
          return const LoginOrRegister();
        } else {
          final checkMemberRequest = ref
              .watch(userHasStudyGroupRequest(_firebaseAuth.currentUser!.uid));

          final userInfo =
              ref.watch(userInfoProvider(_firebaseAuth.currentUser!.uid));
          return PopScope(
            canPop: false,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    userInfo.when(
                      data: (names) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            names.name ??
                                _firebaseAuth.currentUser!.displayName!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
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
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[400]!,
                          highlightColor: Colors.grey[300]!,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: const Skeleton(
                                width: 150,
                                height: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: userInfo.when(
                      data: (image) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(userNameProvider.notifier).state =
                                image.name ??
                                    _firebaseAuth.currentUser!.displayName!;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  imageUrl: image.imageUrl ??
                                      _firebaseAuth.currentUser!.photoURL!,
                                  university: image.university,
                                ),
                              ),
                            );

                            ref.read(editProfilePathProvider.notifier).state =
                                null;

                            ref.read(editOrSaveProvider.notifier).state = true;
                          },
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(image.imageUrl ??
                                _firebaseAuth.currentUser!.photoURL!),
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return Center(
                          child: Text('Error: $error'),
                        );
                      },
                      loading: () {
                        return Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(.15),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              body: ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: SizedBox(
                          height: 100,
                          width: 500,
                          child: ClipRRect(
                            child: SvgPicture.asset(
                              'assets/icons/nylo_v1.svg',
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.fitWidth,
                              height: 125,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 40),
                        child: Text(
                          "Connect with study partners and tutors easily.",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                ref.read(myGroup.notifier).state = true;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                  left: 10,
                                  top: 5,
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isMyGroup
                                      ? Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.subject_outlined,
                                      color: isMyGroup
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Study Group",
                                      style: TextStyle(
                                        color: isMyGroup
                                            ? Theme.of(context)
                                                .colorScheme
                                                .background
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                ref.read(myGroup.notifier).state = false;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isMyGroup
                                      ? null
                                      : Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.done_all_rounded,
                                      color: isMyGroup
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Tutor",
                                      style: TextStyle(
                                        color: isMyGroup
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .background,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isMyGroup)
                        Column(
                          children: [
                            checkMemberRequest.when(
                              data: (value) {
                                return Wrap(
                                  spacing:
                                      8, // adjust spacing between items as needed
                                  runSpacing: 8, // adjust run spacing as needed
                                  children: CategoryModel.studyGroupCategories(
                                          context, ref)
                                      .map((category) {
                                    return SizedBox(
                                      width: 200,
                                      child: Category(
                                        text: category.name,
                                        iconPath: category.iconPath,
                                        onTap: category.onTap,
                                        caption: category.caption,
                                        notification:
                                            category.name == "Study Groups" &&
                                                value,
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                              error: (error, stackTrace) {
                                return Center(
                                  child: Text('Error: $error'),
                                );
                              },
                              loading: () {
                                return Container(
                                  height: 400,
                                  margin: const EdgeInsets.all(10),
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    children: List.generate(4, (index) {
                                      return const HomeCategoryLoading();
                                    }),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      if (!isMyGroup)
                        Column(
                          children: [
                            checkMemberRequest.when(
                              data: (value) {
                                return Wrap(
                                  spacing:
                                      8, // adjust spacing between items as needed
                                  runSpacing: 8, // adjust run spacing as needed
                                  children: CategoryModel.tutorCategories(
                                          context, ref)
                                      .map((category) {
                                    return SizedBox(
                                      width: 200,
                                      child: Category(
                                        text: category.name,
                                        iconPath: category.iconPath,
                                        onTap: category.onTap,
                                        caption: category.caption,
                                        notification:
                                            category.name == "Study Groups" &&
                                                value,
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                              error: (error, stackTrace) {
                                return Center(
                                  child: Text('Error: $error'),
                                );
                              },
                              loading: () {
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 400,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    children: List.generate(4, (index) {
                                      return const HomeCategoryLoading();
                                    }),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
