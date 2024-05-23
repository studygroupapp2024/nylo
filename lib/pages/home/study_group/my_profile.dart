import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/containers/chat_info_container.dart';
import 'package:nylo/components/information_snackbar.dart';
import 'package:nylo/components/textfields/rounded_textfield_title.dart';
import 'package:nylo/pages/home/study_group/my_home.dart';
import 'package:nylo/structure/auth/login_or_register.dart';
import 'package:nylo/structure/providers/auth_provider.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:nylo/structure/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  final String imageUrl;
  final String name;
  final String university;

  ProfilePage(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.university});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editOrSave = ref.watch(editOrSaveProvider);
    _nameController.text = name;
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
          editOrSave
              ? IconButton(
                  onPressed: () {
                    ref
                        .read(editOrSaveProvider.notifier)
                        .update((state) => false);
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                )
              : TextButton(
                  onPressed: () async {
                    ref
                        .read(editOrSaveProvider.notifier)
                        .update((state) => true);

                    FocusScope.of(context).unfocus();

                    if (_nameController.text.isEmpty) {
                      informationSnackBar(
                        context,
                        Icons.notifications,
                        "Please enter your name",
                      );
                    } else {
                      ref.read(userInfoService).changeProfilePicture(
                            ref.watch(editProfilePathNameProvider).toString(),
                            ref.watch(editProfileNameProvider),
                            _firebaseAuth.currentUser!.uid,
                            ref.watch(setGlobalUniversityId),
                            _nameController.text,
                          );

                      informationSnackBar(
                        context,
                        Icons.notifications,
                        "Your profile picture has been updated",
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
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
                  SizedBox(
                    height: 125,
                    width: 125,
                    child: GestureDetector(
                      onTap: editOrSave
                          ? null
                          : () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: [
                                  'jpg',
                                  'png',
                                ],
                              );

                              if (result == null) {
                                informationSnackBar(
                                  context,
                                  Icons.info_outline,
                                  "No image has been selected.",
                                );

                                return;
                              }
                              final path = result.files.single.path;
                              final filename = result.files.single.name;

                              ref.read(editProfilePathProvider.notifier).state =
                                  File(path.toString());

                              ref
                                  .read(editProfilePathNameProvider.notifier)
                                  .state = path.toString();

                              ref.read(editProfileNameProvider.notifier).state =
                                  filename;
                            },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              imageUrl,
                            ),
                            radius: 60,
                          ),
                          if (ref.watch(editProfilePathProvider) != null)
                            CircleAvatar(
                              backgroundImage: FileImage(
                                  ref.watch(editProfilePathProvider)!),
                              radius: 60,
                            ),
                          if (!editOrSave)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  radius: 13,
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (editOrSave)
                    Text(
                      name,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  if (!editOrSave)
                    RoundedTextFieldTitle(
                      title: "Name",
                      hinttext: "Enter your name",
                      controller: _nameController,
                      onChange: null,
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (editOrSave)
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
            if (editOrSave)
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
