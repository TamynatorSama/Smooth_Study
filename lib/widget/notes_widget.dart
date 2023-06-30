import 'package:flutter/material.dart';

class NotesWidget extends StatelessWidget {
  final Size size;
  final String head;
  final String body;

  const NotesWidget({
    super.key,
    required this.size,
    required this.head,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (size.height * 0.085).clamp(65, 80),
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical:12),
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
            margin: const EdgeInsets.only(right: 16,top: 3,bottom: 3),
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
                head,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          //  const   SizedBox(height: 4,),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width * 0.6),
                child: Text(
                  body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12),
                ),
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
