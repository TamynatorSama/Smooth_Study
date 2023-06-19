import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppProvider extends ChangeNotifier {

  SmoothStudyModel? model;



  Future<void> getListOfCourses() async {
    FirebaseFirestore cloudFireStore = FirebaseFirestore.instance;
    final ref = cloudFireStore.collection("Smooth_Study");
    final docs = await ref.get();
    model = SmoothStudyModel.fromJson(docs.docs.first.data());
  }

  Future<void> getMaterials()async{

    Reference materialRef = FirebaseStorage.instance.ref().child("/${model!.departments.first.levels.first.courses.first.materialFolder}");

    var test = await materialRef.listAll();
    var file = test.items.first;
    print(file.name);

    

  }

}
