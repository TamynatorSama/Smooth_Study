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
      height: (size.height * 0.08).clamp(65, 75),
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      padding: const EdgeInsets.all(16),
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
           const   SizedBox(height: 4,),
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
          // const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded)
        ],
      ),
    );
  }
}
