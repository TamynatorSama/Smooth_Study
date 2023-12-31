import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/notes_model.dart';

class NoteWidget extends StatelessWidget {
  final NoteModel note;
  final Function() callback;
  final String courseCode;
  final Size size;
  const NoteWidget({
    super.key,
    required this.note,
    required this.size,
    required this.callback,
    required this.courseCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: size.width * 0.7,
      height: size.height * 0.09,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(0, 0, 0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 45,
            width: 45,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF6259FF),
            ),
            child: SvgPicture.asset('assets/svg/notes.svg'),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.head.isEmpty ? note.body.split(' ')[0] : note.head,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          const SizedBox(width: 8),

              SizedBox(
                width: 150,
                child: Text(
                  note.body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton(
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
            itemBuilder: (context) => [
              PopupMenuItem(
                
                onTap: () {
                  Provider.of<AppProvider>(context, listen: false).deleteNote(
                    note: note,
                  );
                  callback();
                },
                child: Text(
                  'Delete Note',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
