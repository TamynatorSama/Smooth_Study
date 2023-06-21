import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/utils/material_box.dart';

class CourseMaterialListing extends StatefulWidget {
  final Courses course;
  final String levelName;
  const CourseMaterialListing(
      {super.key, required this.course, required this.levelName});

  @override
  State<CourseMaterialListing> createState() => _CourseMaterialListingState();
}

class _CourseMaterialListingState extends State<CourseMaterialListing> {
  bool isLoading = false;
  late List<MaterialModel> materials;

  late AppProvider provider;

  @override
  void initState() {
    setState(() {
      materials = MaterialBox.getMaterial(widget.course.materialFolder) ?? [];
    });
    provider = Provider.of<AppProvider>(context, listen: false);
    getMaterials();
    super.initState();
  }

  getMaterials() async {
    if (materials.isEmpty) {
      setState(() {
        isLoading = true;
      });
    }
    var response = await provider.getMaterials(widget.course.materialFolder);
    if (kDebugMode) print(response);
    if (response["status"]) {
      materials = response["data"];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).padding.top,
              horizontal: 24,
            ),
            width: double.maxFinite,
            height: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              image: const DecorationImage(
                alignment: Alignment.centerRight,
                image: AssetImage('assets/back.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Text(
                            "CSC 401",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: "Search Course",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 233, 233, 233),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          // const SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  const Color.fromARGB(255, 228, 228, 228),
                              child: SvgPicture.asset(
                                'assets/svg/bxs_file-doc.svg',
                                width: 25,
                              ),
                            ),
                            title: Text(
                              "The intro to lorem ipsum",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            subtitle: Text(
                              'Jun 12',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert_rounded),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 4,
                          )
                        ],
                      )))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff6259FF),
          extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          label: Row(
            children: [
              const Icon(Icons.add),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Add Note",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          onPressed: () {
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => const PdfViewPage()));
          }),
    );
  }

  void updateMaterial(MaterialModel model) {
    materials = materials.map((e) {
      if (e.fileName == model.fileName) {
        return model;
      }
      return e;
    }).toList();
    setState(() {});
    MaterialBox.materialBox.put(widget.course.materialFolder,
        materials.map((e) => jsonEncode(e.toJson())).toList());
  }
}
