import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/structure/providers/register_provider.dart';

class RoundedTextFieldDropDown extends ConsumerWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final EdgeInsetsGeometry padding;

  const RoundedTextFieldDropDown({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 75,
      color: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: padding,
              child: TextField(
                obscureText: obscureText,
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: hintText,
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (ref.watch(dropDownValueProvider).isNotEmpty)
            DropdownButton<String>(
              value: ref.watch(dropDownValueProvider),
              onChanged: (String? newValue) {
                ref.read(dropDownValueProvider.notifier).state = newValue!;
              },
              items:
                  ref.watch(dropDownListProvider).map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
        ],
      ),
    );
  }
}
