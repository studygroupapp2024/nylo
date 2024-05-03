import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  DateTime dateTimeValue =
      DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);

  final DateFormat formatter = DateFormat('EEEE, MMMM d, y');
  final String formattedDate = formatter.format(dateTimeValue);
  return formattedDate;
}

String formatDateShort(DateTime date) {
  final DateFormat formatter = DateFormat('E, MMM d');
  final String formattedDate = formatter.format(date);
  return formattedDate;
}
