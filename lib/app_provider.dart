import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/model/notes_model.dart';
import 'package:smooth_study/utils/constants.dart';
import 'package:smooth_study/utils/material_box.dart';
import 'package:smooth_study/utils/personal_notes_box.dart';
import 'package:smooth_study/utils/recently_viewed_box.dart';
import 'package:smooth_study/utils/uploading_screen.dart';

class AppProvider extends ChangeNotifier {
  SmoothStudyModel? model;
  List<NoteModel?> noteSearchResult = [];
  bool notesSearched = false;
  List<Courses?> courseSearchResult = [];
  bool coursesSearched = false;
  List<MaterialModel?> materialSearchResult = [];
  bool materialsSearched = false;
  UploadTask? task;

  List<NoteModel> notes = [];
  bool error = false;

  getNotes(String materialName) {
    notes = PersonalNotesBox().getNotes(materialName);
    notifyListeners();
  }

  addOrUpdateNote({
    required NoteModel note,
  }) {
    final newNotes = PersonalNotesBox().addOrUpdateNote(
      note: note,
    );

    notes = newNotes;
    notifyListeners();
  }

  deleteNote({
    required NoteModel note,
  }) {
    final newNotes = PersonalNotesBox().deleteNote(
      note: note,
    );

    if (newNotes != null) {
      notes = newNotes;
      notifyListeners();
    }
  }

  Future<void> deleteMaterial(
    context, {
    required MaterialModel material,
  }) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage
          .ref()
          .child('${material.courseCode}/${material.fileName}')
          .delete();

      RecentViewedBox.remove(material);
    } catch (e) {
      // print(e);
    }
  }

  Future<void> uploadMaterial(
    context, {
    required String materialFolder,
    String? fileName,
    required File file,
  }) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child(
        "$materialFolder/${fileName != null ? '${fileName}.${file.path.split('.').last}' : file.path.split("/").last}");

    UploadTask newtask = ref.putFile(file);
    await Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => UploadMaterial(taskUpdate: newtask)))
        .then((value) {
      if (fileName != null) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> getListOfCourses() async {
    FirebaseFirestore cloudFireStore = FirebaseFirestore.instance;
    final ref = cloudFireStore.collection(collectionName);
    try {
      if (error) {
        error = false;
        notifyListeners();
      }
      final docs = await ref.get();
      try {
        model = SmoothStudyModel.fromJson(docs.docs.first.data());
      } catch (_) {}
    } on FirebaseException {
      if (model == null) {
        error = true;
        notifyListeners();
      }
    } catch (e) {
      if (model == null) {
        error = true;
        notifyListeners();
      }
    }
  }

  Future<Map<String, dynamic>> getMaterials(String materialPath) async {
    List<MaterialModel> coursesMaterial = [];
    List<MaterialModel>? cachedMaterials =
        MaterialBox.getMaterial(materialPath);

    Reference materialRef =
        FirebaseStorage.instance.ref().child("/$materialPath");

    try {
      var materials = await materialRef.listAll();
      if (materials.items.isNotEmpty) {
        for (var material in materials.items) {
          coursesMaterial.add(MaterialModel(
              // The parent folder is the course code anyways so
              courseCode: material.parent?.name ?? 'TST',
              fileName: material.name,
              filePath: await material.getDownloadURL(),
              isLocal: false));
        }

        if (cachedMaterials != null) {
          if (cachedMaterials.isEqual(coursesMaterial)) {
            return {
              "status": true,
              "message": "database sync successful",
              "data": coursesMaterial
            };
          } else {
            var downloadedMaterials = cachedMaterials
                .where((element) => element.hasBeenModified)
                .toList();

            List<MaterialModel> newCourseMaterial = coursesMaterial.map((e) {
              if (downloadedMaterials
                  .where((element) => element.fileName == e.fileName)
                  .isNotEmpty) {
                return downloadedMaterials
                    .where((element) => element.fileName == e.fileName)
                    .first;
              }
              return e;
            }).toList();

            MaterialBox.materialBox.put(materialPath,
                newCourseMaterial.map((e) => jsonEncode(e.toJson())).toList());
            return {
              "status": true,
              "message": "database sync successful",
              "data": newCourseMaterial
            };
          }
        }
        MaterialBox.materialBox.put(materialPath,
            coursesMaterial.map((e) => jsonEncode(e.toJson())).toList());

        return {
          "status": true,
          "message": "database sync successful",
          "data": coursesMaterial
        };
      } else {
        return {
          "status": true,
          "message": "database sync successful",
          "data": [...coursesMaterial, ...cachedMaterials ?? []]
        };
      }
    } on FirebaseException {
      return {
        "status": false,
        "message": "unable to connect with database",
        "data": cachedMaterials
      };
    } catch (e) {
      return {
        "status": false,
        "message": e.toString(),
        "data": cachedMaterials
      };
    }
  }

  void searchMaterials({
    required String value,
    required int lvl,
    required Courses course,
  }) {
    final materialCourse = model!.departments[0].levels[lvl].courses.firstWhere(
      (indexCourse) => indexCourse == course,
      orElse: () => Courses(
        courseCode: 'courseCode',
        courseTitle: 'courseTitle',
        materialFolder: 'materialFolder',
      ),
    );
    if (materialCourse.courseCode == 'courseCode') {
      coursesSearched = true;
      notifyListeners();
      return;
    }

    final allMaterials = MaterialBox.getMaterial(materialCourse.materialFolder);
    if (allMaterials == null) {
      coursesSearched = true;
      notifyListeners();
      return;
    }

    final results = allMaterials
        .map(
          (material) =>
              material.fileName.contains(value) || material.fileName == value
                  ? material
                  : null,
        )
        .toList();

    final nonNullRes = results.where((element) => element != null).toList();

    if (nonNullRes.isEmpty) {
      materialSearchResult = nonNullRes;
      materialsSearched = true;
      notifyListeners();
      return;
    }

    materialSearchResult = nonNullRes;
    materialsSearched = true;
    notifyListeners();
  }

  void clearMaterialSearch() {
    materialsSearched = false;
    materialSearchResult = [];
    notifyListeners();
  }

  void searchCourses({
    required String value,
    required int lvl,
  }) {
    final courses = model!.departments[0].levels[lvl].courses;
    final results = courses.map((course) {
      return course.courseCode.contains(value) ||
              course.courseTitle.contains(value) ||
              course.courseCode == value ||
              course.courseTitle == value
          ? course
          : null;
    }).toList();

    final nonNullRes = results.where((element) => element != null).toList();
    if (nonNullRes.isEmpty) {
      coursesSearched = true;
      courseSearchResult = nonNullRes;
      notifyListeners();
      return;
    }
    courseSearchResult = nonNullRes;
    coursesSearched = true;
    notifyListeners();
  }

  void clearCoursesSearch() {
    coursesSearched = false;
    courseSearchResult = [];
    notifyListeners();
  }

  void searchNotes(String value) {
    noteSearchResult = PersonalNotesBox().searchNotes(value);
    notesSearched = true;
    notifyListeners();
  }

  void clearNotesSearch() {
    notesSearched = false;
    noteSearchResult = [];
    notifyListeners();
  }
}

extension on List {
  bool isEqual(List other) {
    if (other.length == length) {
      if (other.contains(first)) return true;
    }
    return false;
  }
}
