import 'package:flutter/material.dart';

class CourseWidget extends StatelessWidget {
  final Size size;
  final String courseCode;
  final String courseTitle;

  const CourseWidget({
    super.key,
    required this.size,
    required this.courseCode,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: double.maxFinite,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).primaryColor,
            ),
          ),
          Column(
            children: [
              Text(
                courseCode,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                courseTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded)
        ],
      ),
    );
  }
}
