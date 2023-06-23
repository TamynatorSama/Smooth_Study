import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MusicNoteWidget extends StatelessWidget {
  final String noteTitle;
  final String note;
  final Size size;
  const MusicNoteWidget({
    super.key,
    required this.noteTitle,
    required this.note,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.1,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Color(0x00000080)),
      ]),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFF6259FF)),
            child: SvgPicture.asset('assets/svg/notes.svg'),
          ),
          Column(
            children: [
              Text(noteTitle),
              Text(
                note,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0x80000000),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
