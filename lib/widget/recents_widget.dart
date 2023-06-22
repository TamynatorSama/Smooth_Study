import 'package:flutter/material.dart';

class RecentWidget extends StatelessWidget {
  final String courseCode;
  final String title;
  final bool isDoc;
  final Size size;

  const RecentWidget({
    super.key,
    required this.courseCode,
    required this.title,
    required this.size,
    this.isDoc = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: size.height * 0.15,
        width: size.width * 0.2,
      ),
    );
  }
}
