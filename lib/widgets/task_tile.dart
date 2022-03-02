import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/models/notification.dart';
import 'package:todoapp/utils/utils.dart';

import 'notifications.dart';

class TaskTile extends StatefulWidget {
  Task task;

  TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final controller = SheetController();

  @override
  Widget build(BuildContext context) {
    bool isDone = widget.task.isDone == 0 ? false : true;
    LocalizationDelegate localizedDelegate = LocalizedApp.of(context).delegate;
    DateFormat dateTimeFormatter = DateFormat("yMd", localizedDelegate.currentLocale.languageCode).add_Hm();
    DateFormat dateFormatter = DateFormat("yMd", localizedDelegate.currentLocale.languageCode);

    Future<void> showBottomSheetDialog(BuildContext context) async {
      final formKey = GlobalKey<FormState>();
      final TextEditingController _newTaskController = TextEditingController();
      final TextEditingController _taskDetailsController = TextEditingController();
      final TextEditingController _dateController = TextEditingController();
      DateTime? selectedDate;

      _newTaskController.text = widget.task.name;
      _taskDetailsController.text = widget.task.description!;

      if (!widget.task.notificationTime.toString().startsWith('0')) {
        _dateController.text = DateFormat('H:m d/M/y').format(DateTime.fromMillisecondsSinceEpoch(widget.task.notificationTime));
      }

      await showSlidingBottomSheet(context, builder: (context) {
        return SlidingSheetDialog(
          cornerRadius: 15,
          controller: controller,
          duration: const Duration(milliseconds: 500),
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1.0],
            initialSnap: 1.0,
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          scrollSpec: const ScrollSpec(
            showScrollbar: true,
          ),
          isDismissable: true,
          dismissOnBackdropTap: true,
          isBackdropInteractable: true,
          builder: (context, state) => Material(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                child: Wrap(
                  runSpacing: 15,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            Provider.of<MyDb>(context, listen: false).deleteTaskById(widget.task.id);
                            await AwesomeNotifications().cancelSchedule(widget.task.notificationId!);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      controller: _newTaskController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: Theme.of(context).textTheme.bodyText1,
                      enabled: widget.task.isDone == 1 ? false : true,
                      decoration: InputDecoration(
                        labelText: translate("tasks_page.new_task"),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translate("all_pages.required_field");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _taskDetailsController,
                      maxLines: null,
                      enabled: widget.task.isDone == 1 ? false : true,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        labelText: translate("tasks_page.details"),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () async {
                        selectedDate = await DatePicker.showDateTimePicker(
                          context,
                          minTime: DateTime.now(),
                          maxTime: DateTime(DateTime.now().year + 3),
                          currentTime: DateTime.now(),
                          onConfirm: (date) {
                            selectedDate = date;

                            setState(() {
                              _dateController.text = DateFormat('H:m d/M/y').format(date);
                            });
                          },
                        );
                      },
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        labelText: translate("tasks_page.datetime"),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate("all_pages.created_at", args: {
                            "date": dateTimeFormatter.format(DateTime.fromMicrosecondsSinceEpoch(
                              widget.task.createdAt * 1000,
                            ))
                          }),
                          style: GoogleFonts.getFont(
                            "Inter",
                            color: const Color(0xFFB9B9BE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          translate("all_pages.updated_at", args: {
                            "date": dateTimeFormatter.format(DateTime.fromMicrosecondsSinceEpoch(
                              widget.task.updatedAt * 1000,
                            ))
                          }),
                          style: GoogleFonts.getFont(
                            "Inter",
                            color: const Color(0xFFB9B9BE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          footerBuilder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: TextButton(
                    onPressed: widget.task.isDone == 0
                        ? () {
                            if (formKey.currentState!.validate()) {
                              AwesomeNotifications().cancelSchedule(widget.task.id);

                              int id = generateId();

                              Provider.of<MyDb>(context, listen: false)
                                  .updateTaskById(
                                id,
                                _newTaskController.text.trim(),
                                _taskDetailsController.text.trim(),
                                widget.task.isDone,
                                DateTime.now().millisecondsSinceEpoch,
                                widget.task.id,
                                widget.task.notificationTime,
                              )
                                  .then((value) {
                                if (selectedDate != null) {
                                  createReminderNotification(
                                    id: id,
                                    title: _newTaskController.text.trim(),
                                    notificationSchedule: NotificationWeekAndTime(
                                      dateTime: selectedDate!,
                                      repeat: false,
                                    ),
                                  );
                                }
                              });

                              Navigator.pop(context);
                            }
                          }
                        : null,
                    child: Text(
                      translate("all_pages.save"),
                      style: GoogleFonts.getFont("Inter", fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      });
    }

    return ListTile(
      title: Text(
        widget.task.name,
        style: widget.task.isDone == 1 ? Theme.of(context).textTheme.headline2 : Theme.of(context).textTheme.headline1,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.task.description != null && widget.task.description!.isNotEmpty)
            Expanded(
              child: Text(
                widget.task.description ?? "",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          Text(
            dateFormatter.format(
              DateTime.fromMicrosecondsSinceEpoch(
                widget.task.updatedAt * 1000,
              ),
            ),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
      onTap: () => WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => showBottomSheetDialog(context)),
      leading: IconButton(
          onPressed: () {
            isDone = !isDone;

            Provider.of<MyDb>(context, listen: false).updateTaskById(
              widget.task.notificationId,
              widget.task.name,
              widget.task.description,
              isDone ? 1 : 0,
              widget.task.updatedAt,
              widget.task.id,
              widget.task.notificationTime,
            );
          },
          icon: widget.task.isDone == 1
              ? const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                )
              : const Icon(Icons.circle_outlined)),
      trailing: IconButton(
          onPressed: () async {
            Provider.of<MyDb>(context, listen: false).deleteTaskById(widget.task.id);
            await AwesomeNotifications().cancelSchedule(widget.task.notificationId!);
          },
          icon: const Icon(Icons.close)),
    );
  }
}
