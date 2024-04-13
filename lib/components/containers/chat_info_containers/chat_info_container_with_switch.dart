import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/providers/groupchat_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class ChatInfoContainerWithSwitch extends ConsumerWidget {
  const ChatInfoContainerWithSwitch({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    required this.groupChatId,
  });

  final Function()? onTap;
  final String title;
  final IconData icon;
  final String groupChatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final singleUserGroupChatInformation =
        ref.watch(singleMemberGroupChatInformationProvider(groupChatId));

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              singleUserGroupChatInformation.when(
                data: (data) {
                  return Switch(
                    inactiveThumbColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    activeColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    trackOutlineColor:
                        MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.orange.withOpacity(.48);
                        }
                        if (states.contains(MaterialState.selected)) {
                          return null; // Make the outline disappear when the Switch is active
                        }
                        return Theme.of(context).colorScheme.tertiaryContainer;
                      },
                    ),
                    value: data.receiveNotification,
                    onChanged: (value) {
                      ref.read(groupChatProvider).configureNotification(
                            groupChatId,
                            ref.watch(setGlobalUniversityId),
                            firebaseAuth.currentUser!.uid,
                            value,
                          );
                      print("value: $value");
                    },
                  );
                },
                error: (error, stackTrace) {
                  return Text(error.toString());
                },
                loading: () {
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
