import 'package:flutter/material.dart';
import 'package:smooth_study/utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/screens/audio_page.dart';
import 'package:smooth_study/screens/dashboard/resuables/level_holder.dart';
import 'package:smooth_study/screens/pdf_view_page.dart';
import 'package:smooth_study/utils/material_box.dart';
import 'package:smooth_study/utils/recently_viewed_box.dart';
import 'package:smooth_study/utils/theme_provider.dart';
import 'package:smooth_study/widget/recent_widget.dart';
import '../courses_page.dart';

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
                        : Expanded(
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior()
                                  .copyWith(overscroll: false),
                              child: SingleChildScrollView(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Consumer<ThemeProvider>(
                                      builder: (context, controller, _) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (_) => CoursesPage(
                                                                currentLevel: provider
                                                                    .model!
                                                                    .departments[
                                                                        0]
                                                                    .levels[0]),
                                                          ));
                                                        },
                                                        child: LevelHolder(
                                                          shape: HolderShape
                                                              .normal,
                                                          backgroundImage:
                                                              'assets/100.png',
                                                          text: provider
                                                              .model!
                                                              .departments[0]
                                                              .levels[0]
                                                              .levelName,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (_) => CoursesPage(
                                                                currentLevel: provider
                                                                    .model!
                                                                    .departments[
                                                                        0]
                                                                    .levels[1]),
                                                          ));
                                                        },
                                                        child: LevelHolder(
                                                          shape: HolderShape
                                                              .normal,
                                                          backgroundImage:
                                                              'assets/200.png',
                                                          text: provider
                                                              .model!
                                                              .departments[0]
                                                              .levels[1]
                                                              .levelName,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (_) => CoursesPage(
                                                            currentLevel:
                                                                provider
                                                                    .model!
                                                                    .departments[
                                                                        0]
                                                                    .levels[2]),
                                                      ));
                                                    },
                                                    child: LevelHolder(
                                                      shape: HolderShape
                                                          .spanHeight,
                                                      backgroundImage:
                                                          'assets/300.png',
                                                      text: provider
                                                          .model!
                                                          .departments[0]
                                                          .levels[2]
                                                          .levelName,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (_) => CoursesPage(
                                                      currentLevel: provider
                                                          .model!
                                                          .departments[0]
                                                          .levels[3]),
                                                ));
                                              },
                                              child: LevelHolder(
                                                shape: HolderShape.spanWidth,
                                                backgroundImage:
                                                    'assets/400.png',
                                                text: provider
                                                    .model!
                                                    .departments[0]
                                                    .levels[3]
                                                    .levelName,
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Recent',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceAround,
                                        //   children: [
                                        //     IconButton(
                                        //       onPressed: () {},
                                        //       icon: const Icon(
                                        //           Icons.arrow_back_ios_new_rounded),

                                        //     ),
                                        //     IconButton(
                                        //       onPressed: () {},
                                        //       icon: const Icon(
                                        //           Icons.arrow_forward_ios_rounded),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                    RecentViewedBox.recentlyViewed.isEmpty
                                        ? Align(alignment: Alignment.center, child:  Padding(padding: const EdgeInsets.all(16),child: Column(
                                          children: [
                                            const SizedBox(height: 20),
                                            SvgPicture.asset('assets/empty.svg'),
                                            const SizedBox(height: 15),
                                            Text('No Recent Docs',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.grey),),
                                          ],
                                        )))
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0),
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: List.generate(
                                                    RecentViewedBox
                                                        .recentlyViewed.length,
                                                    (index) => GestureDetector(
                                                      onTap: () async {
                                                        if (RecentViewedBox
                                                            .recentlyViewed[
                                                                index]
                                                            .fileName
                                                            .split('.')
                                                            .last
                                                            .contains('mp')) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      AudioPage(
                                                                material:
                                                                    RecentViewedBox
                                                                            .recentlyViewed[
                                                                        index],
                                                              ),
                                                            ),
                                                          );
                                                          return;
                                                        }

                                                        var resentlyView =
                                                            await Navigator.of(
                                                                    context)
                                                                .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PdfViewPage(
                                                              materialModel:
                                                                  RecentViewedBox
                                                                          .recentlyViewed[
                                                                      index],
                                                            ),
                                                          ),
                                                        );

                                                        if (resentlyView !=
                                                            null) {
                                                          RecentViewedBox
                                                              .addToList(
                                                                  resentlyView);
                                                          updateMaterial(
                                                              resentlyView);
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: RecentWidget(
                                                        courseCode: 'CSC 101',
                                                        title: RecentViewedBox
                                                            .recentlyViewed[
                                                                index]
                                                            .fileName,
                                                        size: size,
                                                        value: RecentViewedBox
                                                                    .recentlyViewed[
                                                                        index]
                                                                    .totalPages ==
                                                                null
                                                            ? 0
                                                            : RecentViewedBox
                                                                    .recentlyViewed[
                                                                        index]
                                                                    .initialPage /
                                                                RecentViewedBox
                                                                    .recentlyViewed[
                                                                        index]
                                                                    .totalPages!,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          )
                                  ],
                                ),
                              ),
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

void updateMaterial(MaterialModel model) {
  //  var materialCacheList = MaterialBox.materialBox.values;
  //  print(MaterialBox.materialBox.keys);
  // //  var parsed = materialCacheList.map((e){
  // //   print(e);
  // //   return e;
  // //  });
  //  for(var hel in materialCacheList){
  //   print(hel);
  //  }
  //  print(materialCacheList);

  // List<MaterialModel>? materials=MaterialBox.getMaterial(model.) ;
  // MaterialBox.materialBox.put(widget.course.materialFolder,
  //     materials.map((e) => jsonEncode(e.toJson())).toList());
}
