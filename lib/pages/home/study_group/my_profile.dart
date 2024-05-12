import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/chat_info_container.dart';
import 'package:nylo/pages/home/study_group/edit_my_profile.dart';
import 'package:nylo/pages/home/study_group/my_home.dart';
import 'package:nylo/structure/auth/login_or_register.dart';
import 'package:nylo/structure/providers/auth_provider.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  final String imageUrl;
  final String name;
  final String university;

  const ProfilePage(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.university});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // Replace the ProfilePage with another screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          icon: const Icon(Icons.chevron_left),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    name,
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
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        university,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ChatInfoContainer(
                  onTap: () async {
                    ref
                        .read(isLoadingProvider.notifier)
                        .update((state) => true);
                    ref.watch(authProvider).signOut();

                    ref
                        .read(isLoadingProvider.notifier)
                        .update((state) => false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginOrRegister()),
                    );
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
