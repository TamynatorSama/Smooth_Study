import 'package:flutter/material.dart';

class CourseMaterialListing extends StatelessWidget {
  const CourseMaterialListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              color: Color(0xff383838),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40))
            ),
            child: Column(),
          )
        ],
      ),
    );
  }
}