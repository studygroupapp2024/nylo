import 'package:flutter/material.dart';

class RoundedTextFieldTitle extends StatelessWidget {
  final String title;
  final String hinttext;
  final void Function(String)? onChange;
  final TextEditingController controller;
  const RoundedTextFieldTitle(
      {super.key,
      required this.title,
      required this.hinttext,
      required this.controller,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            obscureText: false,
            minLines: 1,
            maxLines: 3,
            controller: controller,
            onChanged: onChange,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.tertiary),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Theme.of(context).colorScheme.secondary,
                filled: true,
                hintText: hinttext,
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
    );
  }
}
