import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Time extends StatelessWidget {
  final Timestamp time;
  const Time({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary, fontSize: 12),
        DateFormat('hh:mm a').format(
          time.toDate(),
        ),
      ),
    );
  }
}
