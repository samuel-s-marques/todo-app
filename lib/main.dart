import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:todoapp/widgets/task_tile.dart';

part 'main.g.dart';

const String tasksBoxName = "tasks";

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  DateTime creationDate;

  Task(this.name, this.description, this.isDone, this.creationDate);
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  await Hive.openBox<Task>(tasksBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final controller = SheetController();
  final TextEditingController _newTaskController = TextEditingController();
  final TextEditingController _taskDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do App"),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings_outlined), onPressed: () {})
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Task>(tasksBoxName).listenable(),
        builder: (BuildContext context, Box<Task> box, Widget? child) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("Sem tarefas"),
            );
          }

          int doneTasks = box.values.where((task) => task.isDone).length;
          int allTasks = box.values.length;

          /*
          * TODO
          * Merge the two listviews builder
          */

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: allTasks,
                itemBuilder: (BuildContext context, int index) {
                  Task? currentTask = box.getAt(index);

                  return !currentTask!.isDone
                      ? TaskTile(
                      index: index,
                          title: currentTask.name,
                          description: currentTask.description,
                          date: currentTask.creationDate,
                          isDone: currentTask.isDone,
                          onPressed: () {
                            currentTask.isDone = !currentTask.isDone;
                            box.putAt(index, currentTask);
                          }, tasksBox: box,
                        )
                      : Container();
                },
              ),
              if (doneTasks > 0)
                const Divider(),
              if (doneTasks > 0)
                Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tarefas completadas",
                      style: GoogleFonts.getFont(
                        "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "$doneTasks/$allTasks",
                      style: GoogleFonts.getFont(
                        "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xFFB9B9BE)
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allTasks,
                itemBuilder: (BuildContext context, int index) {
                  Task? currentTask = box.getAt(index);

                  return currentTask!.isDone
                      ? TaskTile(
                          index: index,
                          title: currentTask.name,
                          description: currentTask.description,
                          date: currentTask.creationDate,
                          isDone: currentTask.isDone,
                          onPressed: () {
                            currentTask.isDone = !currentTask.isDone;
                            box.putAt(index, currentTask);
                          }, tasksBox: box,
                        )
                      : Container();
                },
              )
            ],
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
                    style: GoogleFonts.getFont("Inter", fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: "Detalhes",
                      border: OutlineInputBorder(
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
                      Box<Task> tasksBox = Hive.box<Task>(tasksBoxName);
                      tasksBox.add(Task(
                        _newTaskController.text.trim(),
                        _taskDetailsController.text.trim(),
                        false,
                        DateTime.now(),
                      ));

                      _newTaskController.text = "";
                      _taskDetailsController.text = "";
                    }
                  },
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
