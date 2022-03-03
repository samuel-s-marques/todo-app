import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todoapp/models/notification.dart';

Future<void> createReminderNotification(
    {required int id, required String title, required NotificationWeekAndTime notificationSchedule}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'tasks',
      title: translate('notifications.task_todo'),
      body: title,
    ),
    schedule: NotificationCalendar(
      repeats: notificationSchedule.repeat,
      weekday: notificationSchedule.dateTime.weekday,
      hour: notificationSchedule.dateTime.hour,
      minute: notificationSchedule.dateTime.minute,
      second: 0,
      millisecond: 0,
    ),
  );
}
