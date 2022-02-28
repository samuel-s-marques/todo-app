import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/notification.dart';

Future<NotificationWeekAndTime?> pickSchedule(BuildContext context) async {
  List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  TimeOfDay? timeOfDay;
  DateTime now = DateTime.now();
  int? selectedDay;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Eu quero lembrar disso:"),
        content: Wrap(
          alignment: WrapAlignment.center,
          spacing: 3,
          children: [
            for (int index = 0; index < weekdays.length; index++)
              ElevatedButton(
                onPressed: () {
                  selectedDay = index + 1;
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.teal,
                  ),
                ),
                child: Text(weekdays[index]),
              ),
          ],
        ),
      );
    },
  );

  if (selectedDay != null) {
    timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        now.add(
          const Duration(minutes: 1),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(colorScheme: ColorScheme.light(primary: Colors.teal)),
          child: child!,
        );
      },
    );

    if (timeOfDay != null) {
      return NotificationWeekAndTime(
        dayOfTheWeek: selectedDay!,
        timeOfDay: timeOfDay,
        repeat: false,
      );
    }
  }

  return null;
}
