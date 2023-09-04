import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:smooth_study/screens/course_material_listing.dart';
import 'package:smooth_study/utils/theme_provider.dart';

import '../widget/course_widget.dart';

class CoursesPage extends StatefulWidget {
  final Level currentLevel;
  const CoursesPage({super.key, required this.currentLevel});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late AppProvider provider;
  final FocusNode _focus = FocusNode();
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();

    provider = Provider.of<AppProvider>(context, listen: false);
    searchController.addListener(() {
      if (searchController.text.isEmpty ||
          searchController.text == '' ||
          searchController.text == ' ') {
        provider.clearMaterialSearch();
        return;
      }
      provider.searchCourses(
        lvl: int.parse(widget.currentLevel.levelName.split('')[0]) - 1,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appProvider = Provider.of<AppProvider>(
      context,
      listen: true,
    );

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.top, horizontal: 24),
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
                    fit: BoxFit.fitHeight)),
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
                            widget.currentLevel.levelName,
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
            child: Consumer<ThemeProvider>(
              builder: (context, themeCtrl, _) => TextFormField(
                focusNode: _focus,
                controller: searchController,
                decoration: InputDecoration(
                    suffixIcon: AnimatedCrossFade(
                      firstChild: const SizedBox(),
                      secondChild: IconButton(
                        onPressed: () {
                          _focus.unfocus();
                          searchController.clear();
                          provider.clearCoursesSearch();
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
                      color:
                          themeCtrl.isDarkMode ? null : const Color(0xAAFFFFFF),
                    ),
                    hintText: "Search Course",
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
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
          const SizedBox(height: 18),
          Expanded(
              child: appProvider.courseSearchResult.isEmpty
                  ? appProvider.coursesSearched
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/empty.svg'),
                            const SizedBox(height: 15),
                            Text(
                              'No Results',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                            ),
                          ],
                        )
                      : widget.currentLevel.courses.isEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LottieBuilder.asset('assets/no_notes.json'),
                                  const Center(
                                    child: Text('No Courses'),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  widget.currentLevel.courses.length,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CourseMaterialListing(
                                            course: widget
                                                .currentLevel.courses[index],
                                            levelName:
                                                widget.currentLevel.levelName,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CourseWidget(
                                      size: size,
                                      courseCode: widget.currentLevel
                                          .courses[index].courseCode,
                                      courseTitle: widget.currentLevel
                                          .courses[index].courseTitle,
                                    ),
                                  ),
                                ),
                              ),
                            )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          appProvider.courseSearchResult.length,
                          (index) => GestureDetector(
                            onTap: () {
                              if (appProvider.courseSearchResult[index] ==
                                  null) {
                                return;
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CourseMaterialListing(
                                    course:
                                        appProvider.courseSearchResult[index]!,
                                    levelName: widget.currentLevel.levelName,
                                  ),
                                ),
                              );
                            },
                            child: CourseWidget(
                              size: size,
                              courseCode: provider
                                      .courseSearchResult[index]?.courseCode ??
                                  'Error',
                              courseTitle: provider
                                      .courseSearchResult[index]?.courseTitle ??
                                  'Error',
                            ),
                          ),
                        ),
                      ),
                    )),
        ],
      ),
    );
  }
}
