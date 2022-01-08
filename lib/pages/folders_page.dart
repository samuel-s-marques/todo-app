import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/pages/tasks_page.dart';

class FoldersPage extends StatefulWidget {
  const FoldersPage({Key? key}) : super(key: key);

  @override
  _FoldersPageState createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  final controller = SheetController();
  DateFormat dateTimeFormatter = DateFormat("yMd").add_jm();
  DateFormat dateFormatter = DateFormat("yMd");

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
      body: StreamBuilder(
        stream: Provider.of<MyDb>(context).allFolders().watch(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Icon(
                      Icons.create_new_folder_outlined,
                      color: Color(0xFFB9B9BE),
                      size: 48,
                    ),
                  ),
                  Text(
                    "Sem pastas",
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
              Folder folder = snapshot.data[index];

              int id = folder.id;
              String title = folder.title;
              int colorHexCode = folder.colorHexCode ?? Colors.grey.value;
              int iconCodePoint = folder.iconCodePoint;
              DateTime createdAt =
                  DateTime.fromMicrosecondsSinceEpoch(folder.createdAt * 1000);

              return Card(
                elevation: 2.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  dense: true,
                  title: Text(
                    title,
                    style: GoogleFonts.getFont(
                      "Inter",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "Criado em ${dateFormatter.format(createdAt)}",
                    style: GoogleFonts.getFont(
                      "Inter",
                      color: const Color(0xFFB9B9BE),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: Icon(
                    IconData(iconCodePoint, fontFamily: "MaterialIcons"),
                    color: Color(colorHexCode),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TasksPage(folderId: id)),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showBottomSheetDialog(context: context, folder: folder);
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => showBottomSheetDialog(context: context),
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFF515CC6), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        backgroundColor: const Color(0xFF473FA0),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showBottomSheetDialog(
      {required BuildContext context, Folder? folder}) async {
    final formKey = GlobalKey<FormState>();
    IconData _chosenIcon = Icons.folder;
    Color _chosenColor = Colors.grey;
    final TextEditingController _newFolderController = TextEditingController();

    if (folder != null) {
      _newFolderController.text = folder.title;
      _chosenIcon = IconData(folder.iconCodePoint, fontFamily: "MaterialIcons");
      _chosenColor = Color(folder.colorHexCode ?? 4288585374);
    }

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
                  if (folder != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Provider.of<MyDb>(context, listen: false)
                                .deleteFolderById(folder.id);
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
                    controller: _newFolderController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: GoogleFonts.getFont("Inter", fontSize: 16),
                    autofocus: folder != null ? false : true,
                    decoration: InputDecoration(
                      labelText:
                          folder != null ? "Modificar pasta" : "Nova pasta",
                      border: const OutlineInputBorder(
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
                  OutlinedButton(
                    onPressed: () async {
                      IconData? icon =
                          await FlutterIconPicker.showIconPicker(context);

                      setState(() {
                        _chosenIcon = icon!;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          _chosenIcon,
                          color: _chosenColor,
                        ),
                        Text(
                          "Escolher ícone",
                          style: GoogleFonts.getFont("Inter", fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text(
                                      "Escolha uma cor para a pasta"),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                        pickerColor: _chosenColor,
                                        onColorChanged: (Color color) {
                                          setState(() {
                                            _chosenColor = color;
                                          });
                                        }),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Escolher"))
                                  ],
                                ));
                      },
                      child: Text(
                        "Escolher cor",
                        style: GoogleFonts.getFont("Inter", fontSize: 18),
                      ),
                    ),
                  ),
                  if (folder != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Criado em ${dateTimeFormatter.format(DateTime.fromMicrosecondsSinceEpoch(folder.createdAt * 1000))}",
                          style: GoogleFonts.getFont(
                            "Inter",
                            color: const Color(0xFFB9B9BE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Última modificação: ${dateTimeFormatter.format(DateTime.fromMicrosecondsSinceEpoch(folder.updatedAt * 1000))}",
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (folder != null) {
                      Provider.of<MyDb>(context, listen: false)
                          .updateFolderById(
                              _newFolderController.text.trim(),
                              _chosenColor.value,
                              _chosenIcon.codePoint,
                              DateTime.now().millisecondsSinceEpoch,
                              folder.id);
                    } else {
                      Provider.of<MyDb>(context, listen: false).createFolder(
                        _newFolderController.text.trim(),
                        _chosenColor.value,
                        _chosenIcon.codePoint,
                        DateTime.now().millisecondsSinceEpoch,
                        DateTime.now().millisecondsSinceEpoch,
                      );
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Salvar",
                  style: GoogleFonts.getFont("Inter", fontSize: 18),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
