import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/utils/theme_provider.dart';
import 'package:smooth_study/widget/recent_widget.dart';
import 'courses_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AppProvider _appProvider;
  bool isloading = false;
  late AnimationController _lottieController;

  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);
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
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 42,
              left: 18,
              right: 18,
            ),
            child: Column(
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
                            controller.isDarkMode
                                ? SvgPicture.asset(
                                    'assets/svg/moon.svg',
                                    theme: const SvgTheme(
                                      currentColor: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.sunny),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                // provider.error || !isloading
                //     ? const SizedBox(
                //         height: 22,
                //       )
                //     : const Offstage(),
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
                    : provider.error
                        ? Expanded(
                            child: Center(
                                child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LottieBuilder.asset(
                                "assets/error_new.json",
                                controller: _lottieController,
                                // height: 100,
                                // height: ,
                                width: size.width * 0.7,
                                fit: BoxFit.cover,
                                onLoaded: (p0) {
                                  _lottieController.duration = p0.duration;
                                  _lottieController.forward().then(
                                      (value) => _lottieController.repeat());
                                },
                              ),
                              // SvgPicture.string("""<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="currentColor" fill-rule="evenodd" d="M6.697 6.697a7.5 7.5 0 0 1 12.794 4.927A4.002 4.002 0 0 1 18.5 19.5h-12a5 5 0 0 1-1.667-9.715a7.47 7.47 0 0 1 1.864-3.088ZM12 13a1 1 0 0 1-1-1V9a1 1 0 0 1 2 0v3a1 1 0 0 1-1 1Zm-1.5 2.5a1.5 1.5 0 1 1 3 0a1.5 1.5 0 0 1-3 0Z" clip-rule="evenodd"/></svg>""",width: 200,height: 200,fit: BoxFit.cover,),
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: size.width * 0.8),
                                  child: Text(
                                    "There was an error while trying to connect with the database, chcek your intenet connection and try again",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                255, 97, 97, 97)),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  getData();
                                },
                                child: Container(
                                    width: double.maxFinite,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 20),
                                    constraints: BoxConstraints(
                                        maxWidth: size.width * 0.3),
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff6259FF),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Retry",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.replay_outlined,
                                          color: Colors.white,
                                        )
                                      ],
                                    )),
                              )
                            ],
                          )))
                        : SizedBox(
                            height: size.height * 0.88,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Levels',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Consumer<ThemeProvider>(
                                    builder: (context, controller, _) {
                                  return Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      Column(
                                        children: [
                                          GestureDetector(
                                            //   onTap: () {
                                            //               Navigator.of(context).push(
                                            //                 MaterialPageRoute(
                                            //                   builder: (_) => const CoursesPage(
                                            //                       currentLevel:
                                            //                           ),
                                            // ), ),},
                                            child: Container(
                                              width: size.width * 0.44,
                                              height: size.height * 0.15,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                image: DecorationImage(
                                                  colorFilter: controller
                                                          .isDarkMode
                                                      ? const ColorFilter.mode(
                                                    Color.fromARGB(96, 0, 0, 0),
                                                    BlendMode.srcOver,
                                                  )
                                                      : const ColorFilter.mode(
                                                          Color(0xA0000000),
                                                          BlendMode.srcOver,
                                                        ),
                                                  fit: BoxFit.fill,
                                                  image: const AssetImage(
                                                      'assets/100.jpg'),
                                                ),
                                                color: const Color.fromARGB(
                                                    255, 172, 119, 119),
                                              ),
                                              child: Text(
                                                '100 lvl',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          GestureDetector(
                                            onTap: () {
                                              print(provider.model!.departments
                                                  .first.levels);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => CoursesPage(
                                                    currentLevel: provider
                                                        .model!
                                                        .departments
                                                        .first
                                                        .levels[0],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: size.width * 0.44,
                                              height: size.height * 0.196,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  image: DecorationImage(
                                                    colorFilter: controller
                                                            .isDarkMode
                                                        ? const ColorFilter.mode(
                                                    Color.fromARGB(96, 0, 0, 0),
                                                    BlendMode.srcOver,
                                                  )
                                                        : const ColorFilter
                                                            .mode(
                                                            Color(0xA0000000),
                                                            BlendMode.srcOver,
                                                          ),
                                                    fit: BoxFit.fill,
                                                    image: const AssetImage(
                                                        'assets/200.jpg'),
                                                  ),
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0)),
                                              child: Text(
                                                '200 lvl',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: size.width * 0.44,
                                        height: size.height * 0.36,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            image: DecorationImage(
                                              colorFilter: controller.isDarkMode
                                                  ? const ColorFilter.mode(
                                                    Color.fromARGB(96, 0, 0, 0),
                                                    BlendMode.srcOver,
                                                  )
                                                  : const ColorFilter.mode(
                                                      Color(0xA0000000),
                                                      BlendMode.srcOver,
                                                    ),
                                              fit: BoxFit.fill,
                                              image: const AssetImage(
                                                  'assets/300.jpg'),
                                            ),
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                        child: Text(
                                          '300 lvl',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        height: size.height * 0.18,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          image: DecorationImage(
                                            colorFilter: controller.isDarkMode
                                                ? const ColorFilter.mode(
                                                    Color.fromARGB(96, 0, 0, 0),
                                                    BlendMode.srcOver,
                                                  )
                                                : const ColorFilter.mode(
                                                    Color(0xA0000000),
                                                    BlendMode.srcOver,
                                                  ),
                                            fit: BoxFit.fill,
                                            image: const AssetImage(
                                                'assets/400.png'),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                        child: Text(
                                          '400 lvl',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Recent',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.arrow_back_ios_new_rounded),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.arrow_forward_ios_rounded),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RecentWidget(
                                            courseCode: 'CSC 101',
                                            title: 'Intro to lorem',
                                            size: size,
                                          ),
                                          RecentWidget(
                                            courseCode: 'CSC 101',
                                            title: 'Intro to lorem',
                                            size: size,
                                          ),
                                          RecentWidget(
                                            courseCode: 'CSC 101',
                                            title: 'Intro to lorem',
                                            size: size,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
              ],
            ),
          );
        },
      ),
    );
  }
}
