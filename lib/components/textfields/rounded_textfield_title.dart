import 'package:flutter/material.dart';

class RoundedTextFieldTitle extends StatelessWidget {
  final String title;
  final String hinttext;
  final void Function(String)? onChange;
  final TextEditingController controller;
  final bool? withButton;
  final bool? isDate;
  final void Function()? onPressed;
  const RoundedTextFieldTitle({
    super.key,
    required this.title,
    required this.hinttext,
    required this.controller,
    required this.onChange,
    this.withButton = false,
    this.isDate = false,
    this.onPressed,
  });

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
            readOnly: withButton! ? true : false,
            minLines: 1,
            maxLines: 3,
            controller: controller,
            onChanged: onChange,
            decoration: InputDecoration(
                suffixIcon: withButton!
                    ? GestureDetector(
                        onTap: () {},
                        child: IconButton(
                          onPressed: onPressed,
                          icon: isDate!
                              ? const Icon(Icons.date_range)
                              : const Icon(Icons.schedule),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : null,
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
