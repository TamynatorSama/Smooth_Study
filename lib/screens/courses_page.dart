import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:smooth_study/screens/course_material_listing.dart';
import 'package:smooth_study/utils/theme_provider.dart';

import '../widget/course_widget.dart';

class CoursesPage extends StatelessWidget {
  final Level currentLevel;
  const CoursesPage({super.key, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                            currentLevel.levelName,
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
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: themeCtrl.isDarkMode ? null : const Color(0xAAFFFFFF),
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
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  currentLevel.courses.length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CourseMaterialListing(
                            course: currentLevel.courses[index],
                            levelName: currentLevel.levelName,
                          ),
                        ),
                      );
                    },
                    child: CourseWidget(
                      size: size,
                      courseCode: currentLevel.courses[index].courseCode,
                      courseTitle: currentLevel.courses[index].courseTitle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
