import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:todoapp/models/notification.dart';
import 'package:todoapp/utils/utils.dart';

Future<void> createReminderNotification(NotificationWeekAndTime notificationSchedule) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: generateId(),
      channelKey: 'tasks',
      title: 'Ei! Há tarefas pendentes!',
      body: 'Fazer tal coisa',
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark done',
      )
    ],
    schedule: NotificationCalendar(
      repeats: notificationSchedule.repeat,
      weekday: notificationSchedule.dayOfTheWeek,
      hour: notificationSchedule.timeOfDay.hour,
      minute: notificationSchedule.timeOfDay.minute,
      second: 0,
      millisecond: 0,
    ),
  );
}
