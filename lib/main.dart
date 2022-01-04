import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

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

  Task(this.name, this.description, this.isDone);
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
  bool isSelected = false;
  List<int> selectedTiles = [];
  var _temporaryBox;

  void checkAndSelect(int index) {
    if (selectedTiles.contains(index)) {
      selectedTiles.remove(index);
    } else {
      selectedTiles.add(index);
    }
  }

  void deleteTasks() async {
    for (var index in selectedTiles) {
      await _temporaryBox.deleteAt(index);
    }

    selectedTiles = [];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedTiles.isNotEmpty) {
          setState(() {
            selectedTiles = [];
          });
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("To-Do App"),
          actions: [
            selectedTiles.isNotEmpty
                ? IconButton(
                    onPressed: () => deleteTasks(),
                    icon: const Icon(Icons.delete_outlined))
                : IconButton(
                    icon: const Icon(Icons.settings_outlined), onPressed: () {})
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<Task>(tasksBoxName).listenable(),
          builder: (BuildContext context, Box<Task> box, Widget? child) {
            _temporaryBox = box;

            if (box.values.isEmpty) {
              return const Center(
                child: Text("Sem tarefas"),
              );
            }

            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: box.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    Task? currentTask = box.getAt(index);

                    return !currentTask!.isDone ? ListTile(
                      selectedTileColor: Colors.grey.shade200,
                      selected: selectedTiles.contains(index),
                      onLongPress: () {
                        setState(() {
                          checkAndSelect(index);
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (selectedTiles.isNotEmpty) {
                            checkAndSelect(index);
                          }
                        });
                      },
                      title: Text(currentTask.name),
                      subtitle: currentTask.description.isNotEmpty
                          ? Text(currentTask.description)
                          : null,
                      leading: IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedTiles.isNotEmpty) {
                                checkAndSelect(index);
                              } else {
                                currentTask.isDone = !currentTask.isDone;
                              }
                            });
                          },
                          icon: selectedTiles.contains(index)
                              ? const Icon(Icons.circle)
                              : currentTask.isDone
                                  ? const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    )
                                  : const Icon(Icons.circle_outlined)),
                    ) : Container();
                  },
                ),
                Divider(),
                Row(
                  children: const [
                    Text("Tarefas completadas")
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: box.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    Task? currentTask = box.getAt(index);

                    return currentTask!.isDone ? ListTile(
                      selectedTileColor: Colors.grey.shade200,
                      selected: selectedTiles.contains(index),
                      onLongPress: () {
                        setState(() {
                          checkAndSelect(index);
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (selectedTiles.isNotEmpty) {
                            checkAndSelect(index);
                          }
                        });
                      },
                      title: Text(currentTask.name),
                      subtitle: currentTask.description.isNotEmpty
                          ? Text(currentTask.description)
                          : null,
                      leading: IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedTiles.isNotEmpty) {
                                checkAndSelect(index);
                              } else {
                                currentTask.isDone = !currentTask.isDone;
                              }
                            });
                          },
                          icon: selectedTiles.contains(index)
                              ? const Icon(Icons.circle)
                              : currentTask.isDone
                                  ? const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    )
                                  : const Icon(Icons.circle_outlined)),
                    ) : Container();
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
      ),
    );
  }

  Future<void> showBottomSheetDialog(BuildContext context) async {
    TextEditingController _newTaskController = TextEditingController();
    TextEditingController _taskDetailsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        cornerRadius: 15,
        controller: controller,
        duration: const Duration(milliseconds: 500),
        snapSpec: const SnapSpec(
          snap: true,
          initialSnap: 0.3,
        ),
        scrollSpec: const ScrollSpec(
          showScrollbar: true,
        ),
        minHeight: 200,
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
                      tasksBox.add(Task(_newTaskController.text.trim(),
                          _taskDetailsController.text.trim(), false));
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
