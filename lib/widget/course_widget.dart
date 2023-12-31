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
      height: (size.height * 0.087).clamp(75, 85),
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal:16,vertical: 14),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const[
          BoxShadow(
            color: Colors.black,
            blurRadius: 0.7,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
            height: double.maxFinite,
            width: 6,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).primaryColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
          
            ],
          ),
          const Icon(Icons.arrow_forward_ios_rounded)
        ],
      ),
    );
  }
}
