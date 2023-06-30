import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_file/storage_io.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smooth_study/model/notes_model.dart';
import 'package:smooth_study/screens/notes/single_note_view_page.dart';
import 'package:smooth_study/utils/download_notifier.dart';
import 'package:smooth_study/widget/notes_widget.dart';
import 'package:uuid/uuid.dart';

class AudioPage extends StatefulWidget {
  final MaterialModel material;
  const AudioPage({
    super.key,
    required this.material,
  });

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> with TickerProviderStateMixin {
  late AudioPlayer audioPlayer;
  final storageIO = InternetFileStorageIO();
  bool tst = false;
  late AnimationController _playCtrl;
  late Animation<double> _playAnimation;
  late AnimationController _forwardCtrl;
  late Animation<double> _forwardAnimation;
  late AnimationController _reverseCtrl;
  late Animation<double> _reverseAnimation;

  @override
  initState() {
    super.initState();
    audioPlayer = AudioPlayer()..setLoopMode(LoopMode.one);
    if (widget.material.isLocal) {
      audioPlayer.setFilePath(widget.material.filePath);
    } else {
      audioPlayer.setUrl(widget.material.filePath);
    }

    Provider.of<AppProvider>(
      context,
      listen: false,
    ).getNotes(widget.material.fileName);
    _forwardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _forwardAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(_forwardCtrl);

    _reverseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _reverseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(_reverseCtrl);

    _playCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _playAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(_playCtrl);
  }

  downloadFile(String downloadLink) async {
    String? path = await downloadNotifier.downloadMaterial(
        storageIO: storageIO,
        downloadLink: widget.material.filePath,
        fileName: widget.material.fileName);
    if (path != null && path.isNotEmpty) {
      widget.material.filePath = path;
      widget.material.isLocal = true;
      Duration currentDuration = audioPlayer.position;
      await audioPlayer.setFilePath(path, initialPosition: currentDuration);
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _forwardCtrl.dispose();
    _playCtrl.dispose();
    _reverseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    bottom: 10,
                    left: 16,
                    right: 16,
                  ),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: Theme.of(context).cardColor,
                  ),
                  // height: size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: Navigator.of(context).pop,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6),
                              child: Text(
                                widget.material.fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListenableBuilder(
                          listenable: downloadNotifier,
                          builder: (context, child) {
                            return Row(
                              children: [
                                downloadNotifier.downloads
                                        .containsKey(widget.material.fileName)
                                    ? ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxWidth: 20, maxHeight: 10),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18.0),
                                          child: CircularProgressIndicator(
                                            value: (downloadNotifier.downloads[
                                                        widget
                                                            .material.fileName]
                                                    ["progress"]) /
                                                100,
                                            strokeWidth: 3,
                                            color: Colors.white,
                                          ),
                                        ))
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: IconButton(
                                          onPressed: () {
                                            // DownloadNotifier.downloads.any((element) => element.containsKey(widget.materialModel.fileName))''
                                            if (!widget.material.isLocal) {
                                              downloadFile(
                                                  widget.material.filePath);
                                            }
                                          },
                                          icon: Icon(
                                            widget.material.isLocal
                                                ? Icons.check_circle_rounded
                                                : Icons.cloud_download_rounded,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                IconButton(
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SingleNoteViewPage(
                                          courseCode:
                                              widget.material.courseCode,
                                          note: NoteModel(
                                            head: '',
                                            body: '',
                                            materialName:
                                                widget.material.fileName,
                                            uid: const Uuid().v4(),
                                          ),
                                        ),
                                      ),
                                    ).then((value) => Provider.of<AppProvider>(
                                      context,
                                      listen: false,
                                    ).getNotes(widget.material.fileName));
                                    
                                  },
                                  icon: const Icon(
                                    Icons.note_alt_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          }),
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
                    Icons.headphones,
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
                    GestureDetector(
                      onTap: () async {
                        if (audioPlayer.duration == Duration.zero) return;
                        Duration seek =
                            audioPlayer.position - const Duration(seconds: 10);
                        if (seek <= Duration.zero) {
                          audioPlayer.seek(Duration.zero);
                        } else {
                          audioPlayer.seek(seek);
                        }

                        await _reverseCtrl.forward();
                        _reverseCtrl.reverse();
                      },
                      child: AnimatedBuilder(
                        animation: _reverseAnimation,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(_reverseAnimation.value),
                            child: Icon(
                              Icons.fast_rewind_rounded,
                              color: Theme.of(context).cardColor,
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                    Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () async {
                            if (audioPlayer.playing) {
                              await audioPlayer.pause();
                              return;
                            }
                            await audioPlayer.play();

                            await _playCtrl.forward();
                            _playCtrl.reverse();
                          },
                          child: AnimatedBuilder(
                            animation: _playAnimation,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..scale(_playAnimation.value),
                                child: AnimatedCrossFade(
                                  firstChild: SvgPicture.string(
                                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="#707070"><path fill-rule="evenodd" d="M23 12c0-1.035-.53-2.07-1.591-2.647L8.597 2.385C6.534 1.264 4 2.724 4 5.033V12h19Z" clip-rule="evenodd"/><path d="m8.597 21.614l12.812-6.967A2.988 2.988 0 0 0 23 12H4v6.967c0 2.31 2.534 3.769 4.597 2.648Z" opacity=".5"/></g></svg>',
                                    height: 50,
                                    width: 50,
                                  ),
                                  secondChild: SvgPicture.string(
                                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="#707070"><path d="M2 6c0-1.886 0-2.828.586-3.414C3.172 2 4.114 2 6 2c1.886 0 2.828 0 3.414.586C10 3.172 10 4.114 10 6v12c0 1.886 0 2.828-.586 3.414C8.828 22 7.886 22 6 22c-1.886 0-2.828 0-3.414-.586C2 20.828 2 19.886 2 18V6Z"/><path d="M14 6c0-1.886 0-2.828.586-3.414C15.172 2 16.114 2 18 2c1.886 0 2.828 0 3.414.586C22 3.172 22 4.114 22 6v12c0 1.886 0 2.828-.586 3.414C20.828 22 19.886 22 18 22c-1.886 0-2.828 0-3.414-.586C14 20.828 14 19.886 14 18V6Z" opacity=".5"/></g></svg>',
                                    height: 50,
                                    width: 50,
                                  ),
                                  crossFadeState: snapshot.data!.playing
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 50),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (audioPlayer.duration == Duration.zero) return;
                        Duration seek =
                            audioPlayer.position + const Duration(seconds: 10);
                        if (seek >= audioPlayer.duration!) {
                          audioPlayer.seek(audioPlayer.duration!);
                        } else {
                          audioPlayer.seek(seek);
                        }

                        await _forwardCtrl.forward();
                        _forwardCtrl.reverse();
                      },
                      child: AnimatedBuilder(
                        animation: _forwardAnimation,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(_forwardAnimation.value),
                            child: Icon(
                              Icons.fast_forward_rounded,
                              color: Theme.of(context).cardColor,
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                StreamBuilder<Duration>(
                    stream: audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: size.width * 0.75,
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(18),
                              value: ((snapshot.data ?? Duration.zero)
                                          .inSeconds /
                                      (audioPlayer.duration ?? Duration.zero)
                                          .inSeconds)
                                  .clamp(0, 1),
                              minHeight: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTime(snapshot.data ?? Duration.zero),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 12),
                                ),
                                Text(
                                  formatTime(
                                      audioPlayer.duration ?? Duration.zero),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 36),
                  alignment: Alignment.topLeft,
                  child: const Text('Notes'),
                ),
                Consumer<AppProvider>(
                  builder: (context,value,child) {
                    return Expanded(
                      child: value.notes.isEmpty
                          ? Center(
                              child: Text(
                                'No Notes',
                                style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: const Color.fromARGB(160, 0, 0, 0),
                                        ),
                              ),
                            )
                          : ListView.builder(
                            itemCount: value.notes.length,
                              itemBuilder: (context, index) {
                                return NotesWidget(
                                      size: size,
                                      head: value.notes[index].head,
                                      body: value.notes[index].body,
                                    );
                              },
                            ),
                    );
                  }
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            );
          }),
    );
  }

  String formatTime(Duration audioTime) {
    var audioTimeInSeconds = audioTime.inSeconds;

    int hours = (audioTimeInSeconds / (60 * 60)).floor();
    int minutes = (audioTimeInSeconds / 60).floor();
    int seconds = audioTimeInSeconds.remainder(60);

    String formatedTime = hours > 0
        ? "0:$hours:${minutes > 9 ? '$minutes' : '0$minutes'}:${seconds > 9 ? '$seconds' : '0$seconds'}"
        : "${minutes > 9 ? '$minutes' : '$minutes'}:${seconds > 9 ? '$seconds' : '0$seconds'}";
    return formatedTime;
  }
}
