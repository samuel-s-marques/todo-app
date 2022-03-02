import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:todoapp/models/notification.dart';

Future<void> createReminderNotification(
    {required int id, required String title, required NotificationWeekAndTime notificationSchedule}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'tasks',
      title: 'Ei! Há tarefas pendentes!',
      body: title,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark done',
      )
    ],
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
