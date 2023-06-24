import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecentWidget extends StatelessWidget {
  final String courseCode;
  final String title;
  final bool isDoc;
  final Size size;
  final double value; 

  const RecentWidget({
    super.key,
    required this.courseCode,
    required this.title,
    required this.size,
    this.isDoc = false,
    this.value = 0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(16),
      ),
      width: size.width * 0.6,
      // height: size.height * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            courseCode,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color.fromARGB(255, 228, 228, 228),
                  child: SvgPicture.asset(
                    'assets/svg/bxs_file-doc.svg',
                    width: 25,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width * 0.32),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white,fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          LinearProgressIndicator(
            minHeight: 4,
            value: value,
            color: const Color(0xFBFFFFFF),
            backgroundColor: const Color(0xFF000000).withOpacity(0.3),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
