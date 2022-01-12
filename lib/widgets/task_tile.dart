import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:todoapp/database/database.dart';

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

    Future<void> showBottomSheetDialog(BuildContext context) async {
      final formKey = GlobalKey<FormState>();
      final TextEditingController _newTaskController = TextEditingController();
      final TextEditingController _taskDetailsController =
      TextEditingController();

      _newTaskController.text = widget.task.name;
      _taskDetailsController.text = widget.task.description!;

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
                          onPressed: () {
                            Provider.of<MyDb>(context, listen: false)
                                .deleteTaskById(widget.task.id);
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate("all_pages.created_at", args: {
                            "date": dateTimeFormatter.format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    widget.task.createdAt * 1000))
                          }),
                          style: GoogleFonts.getFont(
                            "Inter",
                            color: const Color(0xFFB9B9BE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          translate("all_pages.updated_at", args: {
                            "date": dateTimeFormatter.format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    widget.task.updatedAt * 1000))
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
        style: widget.task.isDone == 1
            ? Theme.of(context).textTheme.headline2
            : Theme.of(context).textTheme.headline1,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.task.description != null &&
              widget.task.description!.isNotEmpty)
            Expanded(
                child: Text(widget.task.description ?? "",
                    style: Theme.of(context).textTheme.subtitle1)),
          Text(
              dateTimeFormatter.format(DateTime.fromMicrosecondsSinceEpoch(
                  widget.task.updatedAt * 1000)),
              style: Theme.of(context).textTheme.subtitle1),
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
      trailing: IconButton(
          onPressed: () => Provider.of<MyDb>(context, listen: false)
              .deleteTaskById(widget.task.id),
          icon: const Icon(Icons.close)),
    );
  }
}
