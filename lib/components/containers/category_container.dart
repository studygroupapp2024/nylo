import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nylo/components/information_snackbar.dart';

class Category extends StatelessWidget {
  final String text;
  final String iconPath;
  final void Function()? onTap;
  final String caption;
  final bool notification;

  const Category(
      {super.key,
      required this.text,
      required this.iconPath,
      required this.caption,
      required this.notification,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.elliptical(20, 80),
                    bottomLeft: Radius.elliptical(10, 60),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          textAlign: TextAlign.center,
                          caption,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (notification)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    informationSnackBar(
                      context,
                      Icons.notifications,
                      "There is a pending member request.",
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    radius: 25,
                    child: const Icon(Icons.notifications),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
