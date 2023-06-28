import 'package:flutter/material.dart';
import 'package:smooth_study/model/notes_model.dart';
import 'package:smooth_study/utils/personal_notes_box.dart';

class SingleNoteViewPage extends StatefulWidget {
  final NoteModel note;
  final String materialName;
  final String courseCode;
  const SingleNoteViewPage({
    super.key,
    required this.note,
    required this.materialName,
    required this.courseCode,
  });

  @override
  State<SingleNoteViewPage> createState() => _SingleNoteViewPageState();
}

class _SingleNoteViewPageState extends State<SingleNoteViewPage> {
  late TextEditingController headController;
  late TextEditingController bodyController;

  @override
  initState() {
    super.initState();
    headController = TextEditingController(text: widget.note.head);
    bodyController = TextEditingController(text: widget.note.body);
  }

  @override
  dispose() {
    headController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (bodyController.text.isNotEmpty ||
              headController.text.isNotEmpty) {
            final note = NoteModel(
              body: bodyController.text,
              head: headController.text,
              materialName: widget.materialName,
              uid: widget.note.uid,
            );
    
            PersonalNotesBox().addOrUpdateNote(
              materialName: widget.materialName,
              note: note,
            );
          }
    
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.check),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (bodyController.text.isNotEmpty ||
                          headController.text.isNotEmpty) {
                        final note = NoteModel(
                          body: bodyController.text,
                          head: headController.text,
                          materialName: widget.materialName,
                          uid: widget.note.uid,
                        );
    
                        PersonalNotesBox().addOrUpdateNote(
                          materialName: widget.materialName,
                          note: note,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: TextField(
                  minLines: 1,
                  maxLines: 2,
                  controller: headController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: TextField(
                    minLines: null,
                    maxLines: null,
                    controller: bodyController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        label: Text('da')),
                    expands: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
