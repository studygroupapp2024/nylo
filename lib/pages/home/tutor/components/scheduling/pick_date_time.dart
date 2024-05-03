import 'package:flutter/material.dart';

Future<DateTime?> pickDate(BuildContext context, DateTime dateNow) async {
  final date = await showDatePicker(
    context: context,
    initialDate: dateNow,
    firstDate: DateTime(2000),
    lastDate: DateTime(2024).add(const Duration(days: 365)),
  );

  return date;
}

Future<TimeOfDay?> pickTime(BuildContext context, TimeOfDay initialTime) async {
  final time = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );

  return time;
}
