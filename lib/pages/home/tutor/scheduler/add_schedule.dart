import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/information_snackbar.dart';
import 'package:nylo/components/textfields/rounded_textfield_title.dart';
import 'package:nylo/functions/pick_date_time.dart';
import 'package:nylo/functions/time_formatter.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/tutor_schedules_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class AddSchedule extends ConsumerWidget {
  final String classId;
  final String tutorId;

  AddSchedule({
    super.key,
    required this.classId,
    required this.tutorId,
  });

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
                currentDate = ref.watch(dateControllerProvider);
              }
              final DateTime? date = await pickDate(context, currentDate);

              if (date != null) {
                ref.read(dateControllerProvider.notifier).state = date;

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
                  currentTime = ref.watch(startTimeControllerProvider);
                }
                final TimeOfDay? time = await pickTime(context, currentTime);

                if (time != null) {
                  formatTime(time);
                  _startTimeController.text = formatTime(time);
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
                  currentTime = ref.watch(endTimeControllerProvider);
                }
                final TimeOfDay? time = await pickTime(context, currentTime);

                if (time != null) {
                  _endTimeController.text = formatTime(time);
                }
              }),
          const SizedBox(
            height: 25,
          ),
          RoundedButtonWithProgress(
            text: "Schedule Class",
            onTap: () async {
              ref.read(isLoadingProvider.notifier).state = true;

              bool? isSuccess;
              if (_dateController.text.isNotEmpty &&
                  _startTimeController.text.isNotEmpty &&
                  _endTimeController.text.isNotEmpty) {
                isSuccess = await ref.read(tutorSchedulesProvider).addSchedule(
                      ref.watch(dateControllerProvider),
                      _startTimeController.text,
                      _endTimeController.text,
                      tutorId,
                      classId,
                      ref.watch(setGlobalUniversityId),
                    );

                if (isSuccess) {
                  if (context.mounted) {
                    informationSnackBar(
                      context,
                      Icons.notification_add,
                      "The schedule has been added",
                    );
                  }
                  _endTimeController.clear();
                  _startTimeController.clear();
                  _dateController.clear();
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Schedule Creation Failed'),
                    content: const Text('Make sure all fields are filled in.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Okay'),
                      ),
                    ],
                  ),
                );
              }
              ref.read(isLoadingProvider.notifier).state = false;
            },
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: Theme.of(context).colorScheme.tertiaryContainer,
            textcolor: Theme.of(context).colorScheme.background,
          )
        ],
      ),
    );
  }
}
