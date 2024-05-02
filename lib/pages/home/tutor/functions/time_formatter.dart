import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTime(TimeOfDay time) {
  final DateTime dateTime = DateTime.utc(DateTime.now().year,
      DateTime.now().month, DateTime.now().day, time.hour, time.minute);
  final DateFormat formatter = DateFormat('h:mm a');
  final String formattedTime = formatter.format(dateTime);

  return formattedTime;
}
