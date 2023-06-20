import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:smooth_study/screens/courses_page.dart';
import 'package:smooth_study/utils/theme_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AppProvider _appProvider;
  bool isloading = false;

  @override
  void initState() {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isloading = true;
    });
    await _appProvider.getListOfCourses();

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Consumer<AppProvider>(builder: (context, provider, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 18,
              right: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, controller, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Smooth Study',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Row(
                          children: [
                            Switch(
                              value: controller.isDarkMode,
                              onChanged: (val) {
                                if (val) {
                                  controller.setDarkMode();
                                } else {
                                  controller.setLightMode();
                                }
                              },
                            ),
                            
                              controller.isDarkMode ? SvgPicture.asset('assets/svg/moon.svg') :
                       const  Icon(Icons.sunny     ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 16
                ),
                const SizedBox(
                  height: 22,
                ),
                isloading
                    ? Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 0.15 * size.width,
                            width: 0.15 * size.width,
                            child: SpinKitChasingDots(
                              itemBuilder: (context, index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index % 2 == 0
                                        ? const Color.fromARGB(
                                            255, 233, 119, 149)
                                        : const Color(0xff6259FF),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Wrap(
                        children: List.generate(
                            provider.model?.departments.first.levels.length ??
                                4, (index) {
                          Level presentDepartment =
                              provider.model!.departments.first.levels[index];
                          if (index == 0 ||
                              index == provider.model?.departments.length ||
                              index == 4) {
                            return GestureDetector(
                              onTap: () async {
                                // await _appProvider.getMaterials();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CoursesPage(currentLevel: presentDepartment),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).padding.top,
                                  horizontal: 24,
                                ),
                                width: size.height * 0.7,
                                height: size.height * 0.15,
                                decoration: const BoxDecoration(
                                  color: Color(0xff383838),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                    alignment: Alignment.centerRight,
                                    image: AssetImage('assets/lvl.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                child: Text(
                                  presentDepartment.levelName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CoursesPage(
                                      currentLevel: presentDepartment,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).padding.top,
                                  horizontal: 24,
                                ),
                                width: size.height * 0.7,
                                height: size.height * 0.15,
                                decoration: const BoxDecoration(
                                  color: Color(0xff383838),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  image: DecorationImage(
                                    alignment: Alignment.centerRight,
                                    image: AssetImage('assets/lvl.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                child: Text(
                                  '200 lvl',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                // Column(
                //   children: [

                // const SizedBox(
                //   height: 16,
                // ),

                // const SizedBox(
                //   height: 16,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (_) => const CoursesPage(),
                //       ),
                //     );
                //   },
                //   child: Container(
                //     alignment: Alignment.centerLeft,
                //     padding: EdgeInsets.symmetric(
                //       vertical: MediaQuery.of(context).padding.top,
                //       horizontal: 24,
                //     ),
                //     width: size.height * 0.7,
                //     height: size.height * 0.15,
                //     decoration: const BoxDecoration(
                //       color: Color(0xff383838),
                //       borderRadius: BorderRadius.all(Radius.circular(8),
                //       ),
                //       image: DecorationImage(
                //         alignment: Alignment.centerRight,
                //         image: AssetImage('assets/lvl.png'),
                //         fit: BoxFit.fitHeight,
                //       ),
                //     ),
                //     child: Text(
                //       '300 lvl',
                //       style: primaryTextStyle.copyWith(
                //         color: Colors.white,
                //         fontSize: 18,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (_) => const CoursesPage(),
                //       ),
                //     );
                //   },
                //   child: Container(
                //     alignment: Alignment.centerLeft,
                //     padding: EdgeInsets.symmetric(
                //       vertical: MediaQuery.of(context).padding.top,
                //       horizontal: 24,
                //     ),
                //     width: size.height * 0.7,
                //     height: size.height * 0.15,
                //     decoration: const BoxDecoration(
                //       color: Color(0xff383838),
                //       borderRadius: BorderRadius.only(
                //         bottomLeft: Radius.circular(40),
                //         bottomRight: Radius.circular(40),
                //       ),
                //       image: DecorationImage(
                //         alignment: Alignment.centerRight,
                //         image: AssetImage('assets/lvl.png'),
                //         fit: BoxFit.fitHeight,
                //       ),
                //     ),
                //     child: Text(
                //       '400 lvl',
                //       style: primaryTextStyle.copyWith(
                //         color: Colors.white,
                //         fontSize: 18,
                //       ),
                //     ),
                //   ),
                // ),

                //   ],
                // )
              ],
            ),
          ),
        );
      }),
    );
  }
}
