import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoContent extends StatelessWidget {
  final String icon;
  final void Function()? onPressed;
  final String description;
  final String buttonText;
  const NoContent({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
