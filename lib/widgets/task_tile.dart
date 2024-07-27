import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/database/database.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    bool isDone = widget.task.isDone == 0 ? false : true;
    LocalizationDelegate localizedDelegate = LocalizedApp.of(context).delegate;
    DateFormat dateTimeFormatter = DateFormat("yMd", localizedDelegate.currentLocale.languageCode).add_Hm();
    DateFormat dateFormatter = DateFormat("yMd", localizedDelegate.currentLocale.languageCode);

    Future<void> showBottomSheetDialog(BuildContext context) async {
      final formKey = GlobalKey<FormState>();
      final TextEditingController newTaskController = TextEditingController();
      final TextEditingController taskDetailsController = TextEditingController();

      newTaskController.text = widget.task.name;
      taskDetailsController.text = widget.task.description!;

      await showModalBottomSheet(
          context: context,
          enableDrag: true,
          isDismissible: true,
          builder: (context) {
            return Material(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 25,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Wrap(
                    runSpacing: 15,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Provider.of<MyDb>(context, listen: false).deleteTaskById(widget.task.id);
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
                        controller: newTaskController,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: Theme.of(context).textTheme.bodyMedium,
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
                        controller: taskDetailsController,
                        maxLines: null,
                        enabled: widget.task.isDone == 1 ? false : true,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          labelText: translate("tasks_page.details"),
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
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextButton(
                              onPressed: widget.task.isDone == 0
                                  ? () {
                                      if (formKey.currentState!.validate()) {
                                        Provider.of<MyDb>(context, listen: false).updateTaskById(
                                          newTaskController.text.trim(),
                                          taskDetailsController.text.trim(),
                                          widget.task.isDone,
                                          DateTime.now().millisecondsSinceEpoch,
                                          widget.task.id,
                                        );

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
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return ListTile(
      title: Text(
        widget.task.name,
        style: widget.task.isDone == 1 ? Theme.of(context).textTheme.headlineMedium : Theme.of(context).textTheme.headlineLarge,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.task.description != null && widget.task.description!.isNotEmpty)
            Expanded(
              child: Text(
                widget.task.description ?? "",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          Text(
            dateFormatter.format(
              DateTime.fromMicrosecondsSinceEpoch(
                widget.task.updatedAt * 1000,
              ),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      onTap: () => WidgetsBinding.instance.addPostFrameCallback((timeStamp) => showBottomSheetDialog(context)),
      leading: IconButton(
        onPressed: () {
          isDone = !isDone;

          Provider.of<MyDb>(context, listen: false).updateTaskById(
            widget.task.name,
            widget.task.description,
            isDone ? 1 : 0,
            widget.task.updatedAt,
            widget.task.id,
          );
        },
        icon: Icon(
          Icons.check_circle_outline,
          color: widget.task.isDone == 1 ? Colors.green : Colors.grey,
        ),
      ),
      trailing: IconButton(
        onPressed: () => Provider.of<MyDb>(context, listen: false).deleteTaskById(widget.task.id),
        icon: const Icon(Icons.close),
      ),
    );
  }
}
