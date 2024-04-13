import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/category_container.dart';
import 'package:nylo/pages/home/my_profile.dart';
import 'package:nylo/structure/models/category_model.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkMemberRequest =
        ref.watch(userHasStudyGroupRequest(_firebaseAuth.currentUser!.uid));

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
                      names.name,
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
                  return const Center(
                    child: CircularProgressIndicator(),
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                child: userInfo.when(
                  data: (image) {
                    return CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(image.imageUrl),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text('Error: $error'),
                    );
                  },
                  loading: () {
                    return Center(
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Column(
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    checkMemberRequest.when(
                      data: (value) {
                        print("value: $value");
                        return Expanded(
                          child: GridView.builder(
                            itemCount: CategoryModel.getCategories(context, ref)
                                .length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              final category = CategoryModel.getCategories(
                                  context, ref)[index];

                              return Category(
                                text: category.name,
                                iconPath: category.iconPath,
                                onTap: category.onTap,
                                caption: category.caption,
                                notification:
                                    category.name == "Study Groups" && value
                                        ? true
                                        : false,
                              );
                            },
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
