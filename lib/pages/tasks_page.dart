import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/models/tasks_arguments.dart';
import 'package:todoapp/widgets/task_tile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TasksArguments;

    Future<void> showBottomSheetDialog(BuildContext context) async {
      final TextEditingController newTaskController = TextEditingController();
      final TextEditingController taskDetailsController = TextEditingController();
      final formKey = GlobalKey<FormState>();

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
                      TextFormField(
                        controller: newTaskController,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: Theme.of(context).textTheme.bodyLarge,
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
                        controller: taskDetailsController,
                        maxLines: null,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: translate("tasks_page.details"),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Provider.of<MyDb>(context, listen: false).createTask(
                                    newTaskController.text.trim(),
                                    taskDetailsController.text.trim(),
                                    0,
                                    args.folderId,
                                    DateTime.now().millisecondsSinceEpoch,
                                    DateTime.now().millisecondsSinceEpoch,
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
                      ),
                    ],
                  ),
                ),
              ),
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
