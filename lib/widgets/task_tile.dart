import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:todoapp/database/database.dart';

class TaskTile extends StatefulWidget {
  Task task;

  TaskTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final controller = SheetController();
  DateFormat dateTimeFormatter = DateFormat("yMd").add_jm();
  DateFormat dateFormatter = DateFormat("yMd");

  @override
  Widget build(BuildContext context) {
    bool isDone = widget.task.isDone == 0 ? false : true;

    return ListTile(
      title: Text(
        widget.task.name,
        style: GoogleFonts.getFont(
          "Inter",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: widget.task.isDone == 1 ? const Color(0xFFB9B9BE) : Colors.black,
          decoration: widget.task.isDone == 1 ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.task.description != null && widget.task.description!.isNotEmpty)
            Expanded(
              child: Text(
                widget.task.description ?? "",
                style: GoogleFonts.getFont(
                  "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB9B9BE),
                ),
              ),
            ),
          Text(
            dateTimeFormatter.format(DateTime.fromMicrosecondsSinceEpoch(
                widget.task.updatedAt * 1000)),
            style: GoogleFonts.getFont(
              "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB9B9BE),
            ),
          ),
        ],
      ),
      onTap: () => WidgetsBinding.instance!
          .addPostFrameCallback((timeStamp) => showBottomSheetDialog(context)),
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
          icon: widget.task.isDone == 1
              ? const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                )
              : const Icon(Icons.circle_outlined)),
      trailing: IconButton(onPressed: () => Provider.of<MyDb>(context, listen: false).deleteTaskById(widget.task.id), icon: Icon(Icons.close)),
    );
  }

  Future<void> showBottomSheetDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController _newTaskController = TextEditingController();
    final TextEditingController _taskDetailsController =
        TextEditingController();

    _newTaskController.text = widget.task.name;
    _taskDetailsController.text = widget.task.description!;

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
                    controller: _newTaskController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: GoogleFonts.getFont("Inter", fontSize: 16),
                    enabled: widget.task.isDone == 1 ? false : true,
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
                    enabled: widget.task.isDone == 1 ? false : true,
                    style: GoogleFonts.getFont("Inter", fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: "Detalhes",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Criado em ${dateTimeFormatter.format(DateTime.fromMicrosecondsSinceEpoch(widget.task.createdAt * 1000))}",
                        style: GoogleFonts.getFont(
                          "Inter",
                          color: const Color(0xFFB9B9BE),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Última modificação: ${dateTimeFormatter.format(DateTime.fromMicrosecondsSinceEpoch(widget.task.updatedAt * 1000))}",
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
                            Provider.of<MyDb>(context, listen: false)
                                .updateTaskById(
                              _newTaskController.text.trim(),
                              _taskDetailsController.text.trim(),
                              widget.task.isDone,
                              DateTime.now().millisecondsSinceEpoch,
                              widget.task.id,
                            );

                            Navigator.pop(context);
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
