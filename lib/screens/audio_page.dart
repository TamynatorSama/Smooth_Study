import 'package:flutter/material.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:just_audio/just_audio.dart';

class AudioPage extends StatefulWidget {
  final MaterialModel material;
  const AudioPage({
    super.key,
    required this.material,
  });

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late AudioPlayer audioPlayer;

  @override
  initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    if (widget.material.isLocal) {
      audioPlayer.setFilePath(widget.material.filePath);
    } else {
      audioPlayer.setUrl(widget.material.filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                bottom: 16,
                left: 16,
              ),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: Theme.of(context).cardColor,
              ),
              height: size.height * 0.1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.material.fileName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 101,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fast_rewind_rounded,
                  color: Theme.of(context).cardColor,
                  size: 48,
                ),
                IconButton(
                  onPressed: () {
                    audioPlayer.play();
                  },
                  icon: audioPlayer.playing
                      ? Icon(
                          Icons.pause,
                          color: Theme.of(context).cardColor,
                          size: 78,
                        )
                      : Icon(
                          Icons.play_arrow_rounded,
                          color: Theme.of(context).cardColor,
                          size: 78,
                        ),
                ),
                Icon(
                  Icons.fast_forward_rounded,
                  color: Theme.of(context).cardColor,
                  size: 48,
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: size.width * 0.75,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(18),
                    value: audioPlayer.position.inSeconds.toDouble(),
                    minHeight: 12,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2:45',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 12),
                      ),
                      Text(
                        '3:10',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              margin: const EdgeInsets.only(left: 36),
              alignment: Alignment.topLeft,
              child: const Text('Notes'),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'No Notes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color.fromARGB(160, 0, 0, 0),
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
