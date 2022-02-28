import 'package:flutter/material.dart';

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;
  final bool repeat;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
    required this.repeat,
  });
}
