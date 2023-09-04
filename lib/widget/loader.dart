import 'package:flutter/Material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatefulWidget {
  final bool processing;
  Loader({required this.processing, Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController? _lottieController;

  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _lottieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(
      widget.processing
          ? "assets/lottie_process.json"
          : "assets/lottie_done.json",
      controller: _lottieController,
      fit: BoxFit.cover,
      height: 180,
      onLoaded: (composition) async {
        _lottieController!.duration = composition.duration;

        _lottieController!.forward();
        _lottieController!.addListener(() {
          setState(() {});
          if (_lottieController!.isCompleted) {
            if (widget.processing) {
              _lottieController!.repeat();
            }
            // Future.delayed(const Duration(milliseconds: 1500),
            //     () => Navigator.pop(context));
          }
        });
      },
    );
  }
}