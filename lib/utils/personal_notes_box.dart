import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_study/model/notes_model.dart';
import 'package:smooth_study/utils/constants.dart';

class PersonalNotesBox {
  static late Box notesBox;
  static List<NoteModel> _currentNotes = [];

  static Future initialize() async {
    notesBox = await Hive.openBox(notesBoxKey);
  }

  List<NoteModel?> searchNotes(String searchValue) {
    final results = _currentNotes.map((note) {
      return note.head == searchValue ||
              note.body == searchValue ||
              note.head.contains(searchValue) ||
              note.body.contains(searchValue)
          ? note
          : null;
    }).toList();

    final nonNullRes = results.where((element) => element != null).toList();
    if (nonNullRes.isEmpty) {
      return [];
    }
    return nonNullRes;
  }

  clearNotes() async {
    await notesBox.clear();
  }

  List<NoteModel> getNotes(String materialName) {
    try {
      final notes = notesBox.get(materialName, defaultValue: []);

      if (notes.isEmpty) {
        _currentNotes = [];
        return [];
      }
      final List allNotes = jsonDecode(notes);

      final result = allNotes
          .map(
            (note) => NoteModel.fromJson(note),
          )
          .toList();

      _currentNotes = result;
      return result;
    } catch (_) {
      rethrow;
    }
  }

  addOrUpdateNote({
    required String materialName,
    required NoteModel note,
  }) {
    var prevNotes = getNotes(materialName);
    print(prevNotes);
    try {
      final existingNote = prevNotes.firstWhere(
        (element) => element.uid == note.uid,
      );
      prevNotes.remove(existingNote);
      prevNotes = [note, ...prevNotes];
      notesBox.put(
        materialName,
        jsonEncode(prevNotes),
      );
    } catch (_) {
      prevNotes = [note, ...prevNotes];
      notesBox.put(
        materialName,
        jsonEncode(prevNotes),
      );
    }
  }

  List<NoteModel>? deleteNote({
    required NoteModel note,
  }) {
    try {
      var prevNotes = getNotes(note.materialName);

      final existingNote = prevNotes.where(
        (element) => element.uid == note.uid,
      );

      prevNotes.remove(existingNote.first);

      notesBox.put(
        note.materialName,
        jsonEncode(prevNotes),
      );

      return prevNotes;
    } catch (_) {
      return null;
    }
  }
}
