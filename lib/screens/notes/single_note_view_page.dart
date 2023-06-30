import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_study/model/notes_model.dart';
import 'package:smooth_study/utils/personal_notes_box.dart';
import 'package:smooth_study/utils/theme_provider.dart';

class SingleNoteViewPage extends StatefulWidget {
  final NoteModel note;
  final String courseCode;
  const SingleNoteViewPage({
    super.key,
    required this.note,
    required this.courseCode,
  });

  @override
  State<SingleNoteViewPage> createState() => _SingleNoteViewPageState();
}

class _SingleNoteViewPageState extends State<SingleNoteViewPage> {
  late TextEditingController headController;
  late TextEditingController bodyController;
  late FocusNode headFocus;
  late FocusNode bodyFocus;

  bool readOnly = false;
  String? ogHead;
  String? ogBody;

  @override
  initState() {
    headController = TextEditingController(text: widget.note.head);
    bodyController = TextEditingController(text: widget.note.body);
    headFocus = FocusNode();
    bodyFocus = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    headFocus.dispose();
    bodyFocus.dispose();
    headController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (bodyController.text.isNotEmpty ||
      //         headController.text.isNotEmpty) {
      //       final note = NoteModel(
      //         body: bodyController.text,
      //         head: headController.text,
      //         materialName: widget.note.materialName,
      //         uid: widget.note.uid,
      //       );

      //       PersonalNotesBox().addOrUpdateNote(
      //         materialName: widget.note.materialName,
      //         note: note,
      //       );
      //     }

      //     Navigator.of(context).pop();
      //   },
      //   child: const Icon(Icons.check),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (bodyController.text.isNotEmpty ||
                          headController.text.isNotEmpty) {
                        final note = NoteModel(
                          body: bodyController.text,
                          head: headController.text,
                          materialName: widget.note.materialName,
                          uid: widget.note.uid,
                        );

                        PersonalNotesBox().addOrUpdateNote(
                          materialName: widget.note.materialName,
                          note: note,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: headFocus,
                      autofocus: true,
                      readOnly: readOnly,
                      minLines: 1,
                      maxLines: 2,
                      controller: headController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Row(
                    children: readOnly
                        ? [
                            IconButton(
                              onPressed: () async {
                                setState(() {
                                  readOnly = !readOnly;
                                });
                                if (bodyController.text.isEmpty ||
                                    headController.text.isEmpty) {
                                  return;
                                }

                                final note = NoteModel(
                                  body: bodyController.text,
                                  head: headController.text,
                                  materialName: widget.note.materialName,
                                  uid: widget.note.uid,
                                );
                                PersonalNotesBox().addOrUpdateNote(
                                  materialName: widget.note.materialName,
                                  note: note,
                                );
                              },
                              icon: readOnly
                                  ? const Icon(Icons.draw)
                                  : const Icon(Icons.menu_book_outlined),
                            ),
                            IconButton(
                              onPressed: () async {
                                await Share.share(
                                  '${headController.text} ${bodyController.text}',
                                );
                              },
                              icon: const Icon(Icons.share),
                            ),
                            PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              position: PopupMenuPosition.under,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    final note = NoteModel(
                                      body: bodyController.text,
                                      head: headController.text,
                                      materialName: widget.note.materialName,
                                      uid: widget.note.uid,
                                    );

                                    PersonalNotesBox().deleteNote(note: note);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Delete Note',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ]
                        : [
                            IconButton(
                              onPressed: () async {
                                setState(() {
                                  readOnly = !readOnly;
                                });
                                if (bodyController.text.isEmpty ||
                                    headController.text.isEmpty) {
                                  return;
                                }

                                final note = NoteModel(
                                  body: bodyController.text,
                                  head: headController.text,
                                  materialName: widget.note.materialName,
                                  uid: widget.note.uid,
                                );
                                PersonalNotesBox().addOrUpdateNote(
                                  materialName: widget.note.materialName,
                                  note: note,
                                );
                              },
                              icon: const Icon(Icons.check),
                            ),
                          ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 6,
              color: isDarkMode
                  ? const Color.fromARGB(255, 110, 110, 110)
                  : const Color.fromARGB(255, 215, 215, 215),
            ),
            const SizedBox(
              height: 14,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: TextField(
                  focusNode: bodyFocus,
                  readOnly: readOnly,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  controller: bodyController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                    hintText: 'Note',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
