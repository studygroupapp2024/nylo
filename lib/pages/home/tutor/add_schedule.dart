import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/textfields/rounded_textfield_title.dart';
import 'package:nylo/pages/home/tutor/components/pick_date_time.dart';

class AddSchedule extends ConsumerWidget {
  AddSchedule({super.key});

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Schedule"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RoundedTextFieldTitle(
            title: "Date",
            hinttext: "Select Date",
            controller: _dateController,
            onChange: null,
            withButton: true,
            isDate: true,
            onPressed: () async {
              DateTime currentDate;
              if (_dateController.text.isEmpty) {
                currentDate = DateTime.now();
              } else {
                currentDate = ref.watch(_dateControllerProvider);
              }
              final DateTime? date = await pickDate(context, currentDate);

              if (date != null) {
                final DateFormat formatter = DateFormat('EEEE, MMMM d, y');
                final String formattedDate = formatter.format(date);
                _dateController.text = formattedDate;
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          RoundedTextFieldTitle(
              title: "Start Time",
              hinttext: "Select start time",
              controller: _startTimeController,
              onChange: null,
              withButton: true,
              onPressed: () async {
                TimeOfDay currentTime;
                if (_startTimeController.text.isEmpty) {
                  currentTime = TimeOfDay.now();
                } else {
                  currentTime = ref.watch(_startTimeControllerProvider);
                }
                final TimeOfDay? time = await pickTime(context, currentTime);
                print("TIME: $time");
                if (time != null) {
                  final DateTime dateTime = DateTime.utc(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      time.hour,
                      time.minute);
                  final DateFormat formatter = DateFormat('h:mm a');
                  final String formattedTime = formatter.format(dateTime);
                  _startTimeController.text = formattedTime;
                }
              }),
          const SizedBox(
            height: 15,
          ),
          RoundedTextFieldTitle(
              title: "End Time",
              hinttext: "Select end time",
              controller: _endTimeController,
              onChange: null,
              withButton: true,
              onPressed: () async {
                TimeOfDay currentTime;
                if (_endTimeController.text.isEmpty) {
                  currentTime = TimeOfDay.now();
                } else {
                  currentTime = ref.watch(_endTimeControllerProvider);
                }
                final TimeOfDay? time = await pickTime(context, currentTime);
                print("TIME: $time");
                if (time != null) {
                  final DateTime dateTime = DateTime.utc(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      time.hour,
                      time.minute);
                  final DateFormat formatter = DateFormat('h:mm a');
                  final String formattedTime = formatter.format(dateTime);
                  _endTimeController.text = formattedTime;
                }
              }),
          const SizedBox(
            height: 25,
          ),
          RoundedButtonWithProgress(
            text: "Schedule Class",
            onTap: null,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: Theme.of(context).colorScheme.tertiaryContainer,
            textcolor: Theme.of(context).colorScheme.background,
          )
        ],
      ),
    );
  }
}

final _dateControllerProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);
final _startTimeControllerProvider = StateProvider<TimeOfDay>(
  (ref) => TimeOfDay.now(),
);
final _endTimeControllerProvider = StateProvider<TimeOfDay>(
  (ref) => TimeOfDay.now(),
);
