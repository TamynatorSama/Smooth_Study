import 'package:flutter/material.dart';
import 'package:smooth_study/screens/courses_page.dart';
import 'package:smooth_study/utils/theme.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Smooth Study',
                    style: primaryTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Switch(
                        value: false,
                        onChanged: (val) {},
                      ),
                      const Icon(Icons.nightlife),
                    ],
                  ),
                ],
              ),
               const SizedBox(
                height: 16,
              ),
              Text(
                'Good Morning',
                style: primaryTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
               const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CoursesPage(),
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
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      alignment: Alignment.centerRight,
                      image: AssetImage('assets/back.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child: Text(
                    '100 lvl',
                    style: primaryTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CoursesPage(),
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
                    borderRadius: BorderRadius.all(Radius.circular(8)
                    ),
                    image: DecorationImage(
                      alignment: Alignment.centerRight,
                      image: AssetImage('assets/lvl.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child: Text(
                    '200 lvl',
                    style: primaryTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CoursesPage(),
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
                    borderRadius: BorderRadius.all(Radius.circular(8),
                    ),
                    image: DecorationImage(
                      alignment: Alignment.centerRight,
                      image: AssetImage('assets/lvl.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child: Text(
                    '300 lvl',
                    style: primaryTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CoursesPage(),
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
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      alignment: Alignment.centerRight,
                      image: AssetImage('assets/lvl.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child: Text(
                    '400 lvl',
                    style: primaryTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
