import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class MembersContainer extends StatelessWidget {
  final String member;
  final String role;
  final String image;
  final bool isAdmin;
  final String creatorId;
  final void Function() onPressed;
  const MembersContainer({
    super.key,
    required this.member,
    required this.role,
    required this.image,
    required this.isAdmin,
    required this.creatorId,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(
        bottom: 10,
        top: 10,
        right: 10,
        left: 10,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(image),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  member,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  role,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          if (_firebaseAuth.currentUser!.uid == creatorId && !isAdmin)
            IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.remove_circle_outline),
            ),
        ],
      ),
    );
  }
}
