import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/chat_info_container.dart';
import 'package:nylo/pages/home/study_group/edit_my_profile.dart';
import 'package:nylo/structure/auth/auth_service.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthService _auth = AuthService();

  ProfilePage({
    super.key,
  });

  void logout(BuildContext context) {
    _auth.signOut();
//    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo =
        ref.watch(userInfoProvider(_firebaseAuth.currentUser!.uid));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .watch(editProfilePathProvider.notifier)
                  .update((state) => null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(),
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 60,
              ),
              child: userInfo.when(
                data: (user) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: user.imageUrl.isNotEmpty
                              ? NetworkImage(user.imageUrl)
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        user.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            size: 24,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            user.university,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => const CircularProgressIndicator(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ChatInfoContainer(
                  onTap: () {
                    logout(context);
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  },
                  title: "Logout",
                  icon: Icons.logout,
                  chevron: false),
            ),
          ],
        ),
      ),
    );
  }
}
