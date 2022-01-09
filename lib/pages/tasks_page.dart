import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/widgets/task_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key, required this.folderId}) : super(key: key);

  final int folderId;

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final controller = SheetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do App"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Provider.of<MyDb>(context).getDoneTasks(widget.folderId).watch(),
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
                    AppLocalizations.of(context)!.noTasks,
                    style: GoogleFonts.getFont(
                        "Inter",
                        color: const Color(0xFFB9B9BE),
                        fontWeight: FontWeight.w500,
                        fontSize: 28
                    ),
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
            borderRadius: BorderRadius.all(Radius.circular(50))),
        backgroundColor: const Color(0xFF473FA0),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showBottomSheetDialog(BuildContext context) async {
    final TextEditingController _newTaskController = TextEditingController();
    final TextEditingController _taskDetailsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        cornerRadius: 15,
        color: const Color(0xFFFAFAFA),
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
            await controller.snapToExtent(0.3,
                duration: duration, clamp: false);
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
                    style: GoogleFonts.getFont("Inter", fontSize: 16),
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.newTask,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.requiredField;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _taskDetailsController,
                    maxLines: null,
                    style: GoogleFonts.getFont("Inter", fontSize: 16),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.details,
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Provider.of<MyDb>(context, listen: false).createTask(
                        _newTaskController.text.trim(),
                        _taskDetailsController.text.trim(),
                        0,
                        widget.folderId,
                        DateTime.now().millisecondsSinceEpoch,
                        DateTime.now().millisecondsSinceEpoch,
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.save,
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
