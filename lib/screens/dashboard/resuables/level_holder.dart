import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/utils/theme_provider.dart';

class LevelHolder extends StatelessWidget {
  final HolderShape shape;
  final String backgroundImage;
  final String text;
  const LevelHolder({super.key, required this.shape,required this.backgroundImage,required this.text});
  final double height = 130;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: shape == HolderShape.spanHeight ? height * 2 : height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            colorFilter: Provider.of<ThemeProvider>(context).isDarkMode
                ? const ColorFilter.mode(
                    Color.fromARGB(96, 0, 0, 0),
                    BlendMode.srcOver,
                  )
                : const ColorFilter.mode(
                    Color(0xA0000000),
                    BlendMode.srcOver,
                  ),
            fit: BoxFit.fill,
            image: AssetImage(backgroundImage),
          ),
          color: const Color.fromARGB(255, 0, 0, 0)),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}

enum HolderShape { spanHeight, spanWidth, normal }
