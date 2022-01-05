import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatefulWidget {
  String title;
  String description;
  String date;
  bool isDone = false;
  VoidCallback? onPressed;
  VoidCallback? onTap;

  TaskTile({Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
    required this.onPressed,
    required this.onTap,
  }) : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: GoogleFonts.getFont(
          "Inter",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: widget.isDone ? const Color(0xFFB9B9BE) : Colors.black
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
            widget.date,
            style: GoogleFonts.getFont("Inter",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB9B9BE)),
          ),
        ],
      ),
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
}
