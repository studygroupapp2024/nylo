import 'package:flutter/material.dart';

class RoundedTextFieldSuffix extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final EdgeInsetsGeometry padding;
  final String suffixText;
  const RoundedTextFieldSuffix({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.padding,
    required this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        obscureText: obscureText,
        controller: controller,
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
          hintText: hintText,
          suffixIcon: IntrinsicWidth(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 5),
                child: Text(
                  suffixText,
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
