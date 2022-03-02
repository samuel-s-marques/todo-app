import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/models/notification.dart';
import 'package:todoapp/models/tasks_arguments.dart';
import 'package:todoapp/utils/utils.dart';
import 'package:todoapp/widgets/notifications.dart';
import 'package:todoapp/widgets/task_tile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final controller = SheetController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TasksArguments;

    Future<void> showBottomSheetDialog(BuildContext context) async {
      final TextEditingController _newTaskController = TextEditingController();
      final TextEditingController _taskDetailsController = TextEditingController();
      final TextEditingController _dateController = TextEditingController();
      TimeOfDay? selectedTime;
      DateTime? selectedDate;
      final formKey = GlobalKey<FormState>();

      await showSlidingBottomSheet(context, builder: (context) {
        return SlidingSheetDialog(
          cornerRadius: 15,
          controller: controller,
          duration: const Duration(milliseconds: 500),
          isDismissable: true,
          dismissOnBackdropTap: true,
          isBackdropInteractable: true,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1.0],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          onDismissPrevented: (backButton, backDrop) async {
            HapticFeedback.heavyImpact();

            if (backButton || backDrop) {
              const duration = Duration(milliseconds: 300);
              await controller.snapToExtent(0.3, duration: duration, clamp: false);
            }
          },
          builder: (context, state) => Material(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                child: Wrap(
                  runSpacing: 15,
                  children: [
                    TextFormField(
                      controller: _newTaskController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: Theme.of(context).textTheme.bodyText1,
                      autofocus: true,
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
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        int id = generateId();

                        Provider.of<MyDb>(context, listen: false)
                            .createTask(
                          id,
                          _newTaskController.text.trim(),
                          _taskDetailsController.text.trim(),
                          0,
                          args.folderId,
                          DateTime.now().millisecondsSinceEpoch,
                          DateTime.now().millisecondsSinceEpoch,
                          selectedDate?.millisecondsSinceEpoch ?? 0,
                        )
                            .then(
                          (value) {
                            if (_dateController.text.trim().isNotEmpty) {
                              createReminderNotification(
                                id: id,
                                title: _newTaskController.text.trim(),
                                notificationSchedule: NotificationWeekAndTime(
                                  dateTime: selectedDate!,
                                  repeat: false,
                                ),
                              );
                            }
                          },
                        );

                        Navigator.pop(context);
                      }
                    },
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.folderName,
          overflow: TextOverflow.fade,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Provider.of<MyDb>(context).getDoneTasks(args.folderId).watch(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Icon(
                      Icons.add_task_outlined,
                      color: Color(0xFFB9B9BE),
                      size: 48,
                    ),
                  ),
                  Text(
                    translate("tasks_page.no_tasks"),
                    style: GoogleFonts.getFont("Inter", color: const Color(0xFFB9B9BE), fontWeight: FontWeight.w500, fontSize: 28),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Task task = snapshot.data[index];

              return TaskTile(
                task: task,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => showBottomSheetDialog(context),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF515CC6), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        backgroundColor: const Color(0xFF473FA0),
        child: const Icon(Icons.add),
      ),
    );
  }
}
