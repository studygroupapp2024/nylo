import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatusOption extends ConsumerWidget {
  const StatusOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("AVAILABLE: ${ref.watch(selectedAvailable)}");
    print("BOOKED: ${ref.watch(selectedBooked)}");
    print("OCCUPIED: ${ref.watch(selectedOccupied)}");
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Option(
            ref,
            context,
            "Occupied",
            Icons.done,
            () {
              ref.read(selectedAvailable.notifier).state = false;
              ref.read(selectedBooked.notifier).state = false;
              ref.read(selectedOccupied.notifier).state = true;
            },
            ref.watch(selectedAvailable),
            ref.watch(selectedBooked),
            ref.watch(selectedOccupied),
            ref.watch(selectedOccupied)
                ? Theme.of(context).colorScheme.tertiaryContainer
                : Theme.of(context).colorScheme.background,
          ),
          const SizedBox(
            width: 5,
          ),
          Option(
            ref,
            context,
            "Booked",
            Icons.book_online,
            () {
              ref.read(selectedAvailable.notifier).state = false;
              ref.read(selectedBooked.notifier).state = true;
              ref.read(selectedOccupied.notifier).state = false;
            },
            ref.watch(selectedAvailable),
            ref.watch(selectedBooked),
            ref.watch(selectedOccupied),
            ref.watch(selectedBooked)
                ? Theme.of(context).colorScheme.tertiaryContainer
                : Theme.of(context).colorScheme.background,
          ),
          const SizedBox(
            width: 5,
          ),
          Option(
            ref,
            context,
            "Available",
            Icons.event_available,
            () {
              ref.read(selectedAvailable.notifier).state = true;
              ref.read(selectedBooked.notifier).state = false;
              ref.read(selectedOccupied.notifier).state = false;
            },
            ref.watch(selectedAvailable),
            ref.watch(selectedBooked),
            ref.watch(selectedOccupied),
            ref.watch(selectedAvailable)
                ? Theme.of(context).colorScheme.tertiaryContainer
                : Theme.of(context).colorScheme.background,
          ),
        ],
      ),
    );
  }

  Expanded Option(
      WidgetRef ref,
      BuildContext context,
      String text,
      IconData icon,
      void Function() onTap,
      bool available,
      bool booked,
      bool occupied,
      Color? color) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color ?? Theme.of(context).colorScheme.tertiaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: available
                    ? Theme.of(context).colorScheme.background
                    : booked
                        ? Theme.of(context).colorScheme.background
                        : occupied
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: available
                      ? Theme.of(context).colorScheme.background
                      : occupied
                          ? Theme.of(context).colorScheme.background
                          : booked
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final selectedOccupied = StateProvider<bool>((ref) => true);
final selectedBooked = StateProvider<bool>((ref) => false);
final selectedAvailable = StateProvider<bool>((ref) => false);
