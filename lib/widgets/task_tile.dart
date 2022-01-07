import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:todoapp/main.dart';

class TaskTile extends StatefulWidget {
  int index;
  String title;
  String description;
  DateTime date;
  bool isDone = false;
  VoidCallback? onPressed;
  Box<Task> tasksBox;

  TaskTile({
    Key? key,
    required this.index,
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
    required this.onPressed,
    required this.tasksBox,
  }) : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final TextEditingController _newTaskController = TextEditingController();
  final TextEditingController _taskDetailsController = TextEditingController();
  final controller = SheetController();
  DateFormat dateTimeFormatter = DateFormat("yMd").add_jm();
  DateFormat dateFormatter = DateFormat("yMd");

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _newTaskController.text = widget.title;
      _taskDetailsController.text = widget.description;
    });

    return ListTile(
      title: Text(
        widget.title,
        style: GoogleFonts.getFont(
          "Inter",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: widget.isDone ? const Color(0xFFB9B9BE) : Colors.black,
          decoration: widget.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.description,
              style: GoogleFonts.getFont("Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB9B9BE)),
            ),
          ),
          Text(
            dateFormatter.format(widget.date),
            style: GoogleFonts.getFont("Inter",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB9B9BE)),
          ),
        ],
      ),
      onTap: () => WidgetsBinding.instance!
          .addPostFrameCallback((timeStamp) => showBottomSheetDialog(context)),
      leading: IconButton(
          onPressed: widget.onPressed,
          icon: widget.isDone
              ? const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                )
              : const Icon(Icons.circle_outlined)),
    );
  }

  Future<void> showBottomSheetDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        color: const Color(0xFFFAFAFA),
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
                        onPressed: () {
                          widget.tasksBox.deleteAt(widget.index);
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
                    style: GoogleFonts.getFont("Inter", fontSize: 16),
                    enabled: widget.isDone ? false : true,
                    decoration: const InputDecoration(
                      labelText: "Nova tarefa",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo é necessário';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _taskDetailsController,
                    maxLines: null,
                    enabled: widget.isDone ? false : true,
                    style: GoogleFonts.getFont("Inter", fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: "Detalhes",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        dateTimeFormatter.format(widget.date),
                        style: GoogleFonts.getFont(
                          "Inter",
                          color: const Color(0xFFB9B9BE),
                          fontWeight: FontWeight.w500,
                        ),
                      )
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
                  onPressed: !widget.isDone
                      ? () {
                          if (formKey.currentState!.validate()) {
                            widget.tasksBox.putAt(
                              widget.index,
                              Task(
                                _newTaskController.text.trim(),
                                _taskDetailsController.text.trim(),
                                widget.isDone,
                                widget.date,
                              ),
                            );

                            SchedulerBinding.instance!
                                .addPostFrameCallback((_) {
                              _newTaskController.text = "";
                              _taskDetailsController.text = "";
                              Navigator.pop(context);
                            });
                          }
                        }
                      : null,
                  child: Text(
                    "Salvar",
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
}
