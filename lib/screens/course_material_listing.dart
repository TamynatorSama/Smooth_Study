import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/screens/pdf_view_page.dart';
import 'package:smooth_study/screens/notes/all_notes_view_page.dart';
import 'package:smooth_study/utils/material_box.dart';
import 'package:smooth_study/utils/recently_viewed_box.dart';
import 'package:smooth_study/utils/theme_provider.dart';
import './audio_page.dart';

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
  final FocusNode _focus = FocusNode();
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();

    provider = Provider.of<AppProvider>(context, listen: false);
    setState(() {
      materials = MaterialBox.getMaterial(widget.course.materialFolder) ?? [];
    });
    getMaterials();
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        provider.clearMaterialSearch();
        return;
      }
      provider.searchMaterials(
        course: widget.course,
        lvl: int.parse(widget.levelName.split('')[0]) - 1,
        value: searchController.text,
      );
    });

    super.initState();
  }

  @override
  dispose() {
    searchController.dispose();
    super.dispose();
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
    Size size = MediaQuery.of(context).size;
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: isLoading
          ? Center(
              child: SizedBox(
                height: 0.15 * size.width,
                width: 0.15 * size.width,
                child: SpinKitChasingDots(
                  itemBuilder: (context, index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index % 2 == 0
                            ? const Color.fromARGB(255, 233, 119, 149)
                            : const Color(0xff6259FF),
                      ),
                    );
                  },
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).padding.top,
                      horizontal: 24),
                  width: double.maxFinite,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    image: const DecorationImage(
                        alignment: Alignment.centerRight,
                        image: AssetImage('assets/back.png'),
                        fit: BoxFit.fitHeight),
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
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: size.width * 0.7),
                                  child: Text(
                                    widget.course.courseTitle,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            // fontSize: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                  ),
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
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeCtrl, _) => TextFormField(
                      controller: searchController,
                      focusNode: _focus,
                      decoration: InputDecoration(
                          suffixIcon: AnimatedCrossFade(
                            firstChild: const SizedBox(),
                            secondChild: IconButton(
                              onPressed: () {
                                _focus.unfocus();
                                searchController.clear();
                                provider.clearMaterialSearch();
                              },
                              icon: const Icon(Icons.cancel),
                            ),
                            crossFadeState: _focus.hasPrimaryFocus
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 500),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: themeCtrl.isDarkMode
                                ? null
                                : const Color(0xAAFFFFFF),
                          ),
                          hintText: "Search Material",
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xAAFFFFFF),
                                  ),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(54),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(54),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(54),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(54),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(54),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16)),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: themeCtrl.isDarkMode ? null : Colors.white,
                          ),
                    ),
                  ),
                ),
                // const SizedBox(height: 10),
                Expanded(
                    child: appProvider.materialSearchResult.isEmpty
                        ? appProvider.materialsSearched
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LottieBuilder.asset('assets/empty1.json'),
                                  const Center(
                                    child: Text('No Results'),
                                  ),
                                ],
                              )
                            : materials.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LottieBuilder.asset(
                                          'assets/no_notes.json'),
                                      const Center(
                                        child: Text('No Materials ...yet'),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    itemCount: materials.length,
                                    itemBuilder: (context, index) => Column(
                                      children: [
                                        ListTile(
                                            onTap: () async {
                                              if (materials[index]
                                                  .fileName
                                                  .split('.')
                                                  .last
                                                  .contains('mp')) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AudioPage(
                                                      material:
                                                          materials[index],
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              var resentlyView =
                                                  await Navigator.of(context)
                                                      .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfViewPage(
                                                    materialModel:
                                                        materials[index],
                                                  ),
                                                ),
                                              );

                                              if (resentlyView != null) {
                                                RecentViewedBox.addToList(
                                                    resentlyView);
                                                updateMaterial(resentlyView);
                                              }
                                            },
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 228, 228, 228),
                                              child: materials[index]
                                                      .fileName
                                                      .split('.')
                                                      .last
                                                      .contains('mp')
                                                  ? const Icon(
                                                      Icons.music_note_rounded)
                                                  : SvgPicture.asset(
                                                      'assets/svg/bxs_file-doc.svg',
                                                      width: 25,
                                                    ),
                                            ),
                                            title: Text(
                                              materials[index].fileName,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontSize: 15,
                                                  ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: LinearProgressIndicator(
                                                minHeight: 7,
                                                color: const Color(0xff6259FF),
                                                backgroundColor:
                                                    const Color(0xff6259FF)
                                                        .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                value: materials[index]
                                                        .initialPage /
                                                    (materials[index]
                                                            .totalPages ??
                                                        1),
                                              ),
                                            ),
                                            // Text('Jun 12',
                                            //     style: primaryTextStyle.copyWith(
                                            //         fontSize: 14, color: Colors.grey)),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          AllNotesViewPage(
                                                        materialName:
                                                            materials[index]
                                                                .fileName,
                                                        courseCode: widget
                                                            .course.courseCode,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.abc))
                                            // PopupMenuButton(
                                            //   itemBuilder: (context) {
                                            //     return [
                                            //       PopupMenuItem(
                                            //         onTap: () {
                                            //           print('Tapped');
                                            //           Navigator.of(context).push(
                                            //             MaterialPageRoute(
                                            //               builder: (_) =>
                                            //                   AllNotesViewPage(
                                            //                 notes: PersonalNotesBox()
                                            //                     .getNote(
                                            //                         materials[index]),
                                            //                 courseCode: widget
                                            //                     .course.courseCode,
                                            //               ),
                                            //             ),
                                            //           );
                                            //         },
                                            //         child: const Text('View Notes'),
                                            //       ),
                                            //     ];
                                            //   },
                                            // ),
                                            ),
                                        const Divider(
                                          height: 5,
                                          thickness: 4,
                                        )
                                      ],
                                    ),
                                  )
                        : ListView.builder(
                            itemCount: appProvider.materialSearchResult.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    if (appProvider
                                            .materialSearchResult[index] ==
                                        null) return;
                                    if (appProvider.materialSearchResult[index]
                                            ?.fileName
                                            .split('.')
                                            .last
                                            .contains('mp') ??
                                        false) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AudioPage(
                                            material: appProvider
                                                .materialSearchResult[index]!,
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    var resentlyView =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PdfViewPage(
                                          materialModel: appProvider
                                              .materialSearchResult[index]!,
                                        ),
                                      ),
                                    );

                                    if (resentlyView != null) {
                                      RecentViewedBox.addToList(resentlyView);
                                      updateMaterial(resentlyView);
                                    }
                                  },
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: const Color.fromARGB(
                                        255, 228, 228, 228),
                                    child: materials[index]
                                            .fileName
                                            .split('.')
                                            .last
                                            .contains('mp')
                                        ? const Icon(Icons.music_note_rounded)
                                        : SvgPicture.asset(
                                            'assets/svg/bxs_file-doc.svg',
                                            width: 25,
                                          ),
                                  ),
                                  title: Text(
                                    appProvider.materialSearchResult[index]
                                            ?.fileName ??
                                        'Error',
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontSize: 52,
                                        ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: LinearProgressIndicator(
                                      minHeight: 7,
                                      color: const Color(0xff6259FF),
                                      backgroundColor: const Color(0xff6259FF)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                      value: (appProvider
                                                  .materialSearchResult[index]
                                                  ?.initialPage ??
                                              1) /
                                          (appProvider
                                                  .materialSearchResult[index]
                                                  ?.totalPages ??
                                              1),
                                    ),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => AllNotesViewPage(
                                              materialName: appProvider
                                                      .materialSearchResult[
                                                          index]
                                                      ?.fileName ??
                                                  'Error',
                                              courseCode:
                                                  widget.course.courseCode,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.note_add)
                                      //  SvgPicture.asset(
                                      //   'assets/svg/notes.svg',
                                      // ),
                                      ),
                                ),
                                const Divider(
                                  height: 5,
                                  thickness: 4,
                                )
                              ],
                            ),
                          ))
              ],
            ),
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
