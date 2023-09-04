import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';

class MaterialRecordScreen extends StatefulWidget {
  final String materialFolder;
  const MaterialRecordScreen({super.key, required this.materialFolder});

  @override
  State<MaterialRecordScreen> createState() => _MaterialRecordScreenState();
}

class _MaterialRecordScreenState extends State<MaterialRecordScreen>
    with SingleTickerProviderStateMixin {
  late RecorderController noteRecorderController;
  late AnimationController controller;
  late Animation<double> back;
  late Animation<double> mid;
  String? pathToRecord;
  bool hasStartedRecording = false;
  late TextEditingController nameController;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addListener(() {
            setState(() {});
          });
    nameController = TextEditingController(text: "New Note Material");
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      back = Tween<double>(
              begin: (MediaQuery.of(context).size.width * 0.15).clamp(40, 60),
              end: (MediaQuery.of(context).size.width * 0.22).clamp(60, 80))
          .animate(controller);
      mid = Tween<double>(
              begin: (MediaQuery.of(context).size.width * 0.15).clamp(40, 60),
              end: (MediaQuery.of(context).size.width * 0.20).clamp(50, 70))
          .animate(controller);
      setState(() {});
    });

    noteRecorderController = RecorderController()
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    noteRecorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
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
              color: Theme.of(context).canvasColor,
            ),
            height: 90,
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
                          child: IntrinsicWidth(
                            child: TextField(
                              controller: nameController,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                            ),
                          )
                          // Text(
                          //   "kajskajsdkajkdjak",
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          //   style:
                          //       Theme.of(context).textTheme.bodyMedium?.copyWith(
                          //             color: Colors.white,
                          //           ),
                          // ),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.width * 0.24) * 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xff6259FF).withOpacity(0.3),
                      radius: back.value,
                    ),
                    CircleAvatar(
                      backgroundColor: const Color(0xff6259FF).withOpacity(0.5),
                      radius: mid.value,
                    ),
                    CircleAvatar(
                      backgroundColor: const Color(0xff6259FF),
                      radius: (MediaQuery.of(context).size.width * 0.15)
                          .clamp(40, 60),
                      child: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 28 28"><path fill="white" d="M8.5 6.5a4.5 4.5 0 1 1 9 0v7.124a7.513 7.513 0 0 0-4.35 5.373L13 19a4.5 4.5 0 0 1-4.5-4.5v-8ZM13.016 21H13a6.5 6.5 0 0 1-6.5-6.5v-.75a.75.75 0 1 0-1.5 0v.75a8 8 0 0 0 7.25 7.965v2.785a.75.75 0 0 0 1.5 0v-1.477A7.457 7.457 0 0 1 13.016 21Zm7.484 4.5a5 5 0 1 1 0-10a5 5 0 0 1 0 10Zm0 1.5a6.5 6.5 0 1 0 0-13a6.5 6.5 0 0 0 0 13Zm0-3a3.5 3.5 0 1 0 0-7a3.5 3.5 0 0 0 0 7Z"/></svg>',
                        width: 50,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatTime(noteRecorderController.elapsedDuration),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                        height: 20,
                      ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!hasStartedRecording)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            (((MediaQuery.of(context).size.width) - 100) / 7)
                                .floor(),
                            (index) => Container(
                                  width: 3,
                                  height: 3,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: ShapeDecoration(
                                    shape: const StadiumBorder(),
                                    color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color ??
                                        Colors.grey,
                                  ),
                                )),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: AudioWaveforms(
                        size:
                            Size(MediaQuery.of(context).size.width - 48, 40.0),
                        recorderController: noteRecorderController,
                        enableGesture: true,
                        shouldCalculateScrolledPosition: true,
                        waveStyle: WaveStyle(
                            waveColor:
                                Theme.of(context).textTheme.bodyLarge!.color ??
                                    Colors.grey,
                            spacing: 8.0,
                            scaleFactor: 80,
                            showBottom: false,
                            extendWaveform: true,
                            showMiddleLine: false,
                            durationLinesHeight: 5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Theme(
                data:
                    Theme.of(context).copyWith(splashColor: Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          hasStartedRecording = false;
                          pathToRecord =
                              await noteRecorderController.stop(true);
                          controller.stop();
                        },
                        child: SvgPicture.string(
                          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="#707070" d="M12 16c1.671 0 3-1.331 3-3s-1.329-3-3-3s-3 1.331-3 3s1.329 3 3 3z"/><path fill="#707070" d="M20.817 11.186a8.94 8.94 0 0 0-1.355-3.219a9.053 9.053 0 0 0-2.43-2.43a8.95 8.95 0 0 0-3.219-1.355a9.028 9.028 0 0 0-1.838-.18V2L8 5l3.975 3V6.002c.484-.002.968.044 1.435.14a6.961 6.961 0 0 1 2.502 1.053a7.005 7.005 0 0 1 1.892 1.892A6.967 6.967 0 0 1 19 13a7.032 7.032 0 0 1-.55 2.725a7.11 7.11 0 0 1-.644 1.188a7.2 7.2 0 0 1-.858 1.039a7.028 7.028 0 0 1-3.536 1.907a7.13 7.13 0 0 1-2.822 0a6.961 6.961 0 0 1-2.503-1.054a7.002 7.002 0 0 1-1.89-1.89A6.996 6.996 0 0 1 5 13H3a9.02 9.02 0 0 0 1.539 5.034a9.096 9.096 0 0 0 2.428 2.428A8.95 8.95 0 0 0 12 22a9.09 9.09 0 0 0 1.814-.183a9.014 9.014 0 0 0 3.218-1.355a8.886 8.886 0 0 0 1.331-1.099a9.228 9.228 0 0 0 1.1-1.332A8.952 8.952 0 0 0 21 13a9.09 9.09 0 0 0-.183-1.814z"/></svg>',
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!hasStartedRecording) {
                            hasStartedRecording = true;
                            await noteRecorderController.record(
                              bitRate: 48000,
                              sampleRate: 44100,
                              iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
                              androidOutputFormat: AndroidOutputFormat.mpeg4,
                              androidEncoder: AndroidEncoder.aac,
                            );
                            controller
                                .forward()
                                .then((value) => controller.repeat());
                            return;
                          }
                          if (noteRecorderController.isRecording) {
                            await noteRecorderController.pause();
                            controller.stop();
                            return;
                          }
                          await noteRecorderController.record();
                          noteRecorderController.refresh();
                          controller
                              .forward()
                              .then((value) => controller.repeat());
                        },
                        child: AnimatedCrossFade(
                          firstChild: SvgPicture.string(
                            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="#707070"><path fill-rule="evenodd" d="M23 12c0-1.035-.53-2.07-1.591-2.647L8.597 2.385C6.534 1.264 4 2.724 4 5.033V12h19Z" clip-rule="evenodd"/><path d="m8.597 21.614l12.812-6.967A2.988 2.988 0 0 0 23 12H4v6.967c0 2.31 2.534 3.769 4.597 2.648Z" opacity=".5"/></g></svg>',
                            height: 60,
                            width: 60,
                          ),
                          secondChild: SvgPicture.string(
                            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="#707070"><path d="M2 6c0-1.886 0-2.828.586-3.414C3.172 2 4.114 2 6 2c1.886 0 2.828 0 3.414.586C10 3.172 10 4.114 10 6v12c0 1.886 0 2.828-.586 3.414C8.828 22 7.886 22 6 22c-1.886 0-2.828 0-3.414-.586C2 20.828 2 19.886 2 18V6Z"/><path d="M14 6c0-1.886 0-2.828.586-3.414C15.172 2 16.114 2 18 2c1.886 0 2.828 0 3.414.586C22 3.172 22 4.114 22 6v12c0 1.886 0 2.828-.586 3.414C20.828 22 19.886 22 18 22c-1.886 0-2.828 0-3.414-.586C14 20.828 14 19.886 14 18V6Z" opacity=".5"/></g></svg>',
                            height: 60,
                            width: 60,
                          ),
                          crossFadeState: noteRecorderController.isRecording
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 50),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!hasStartedRecording) {
                            return;
                          }
                          noteRecorderController.stop().then((value) async {
                            controller.stop();
                            if (value == null) {
                              return;
                            }
                            Navigator.of(context).pop();
                            await Provider.of<AppProvider>(
                              context,
                              listen: false,
                            ).uploadMaterial(
                              context,
                              fileName: nameController.text,
                              materialFolder: widget.materialFolder,
                              file: File(value),
                            );
                          });
                        },
                        child: SvgPicture.string(
                          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="#707070"><path fill-rule="evenodd" d="M3.464 3.464C2 4.93 2 7.286 2 12c0 4.714 0 7.071 1.464 8.535l17.072-17.07C19.07 2 16.713 2 12 2C7.286 2 4.929 2 3.464 3.464Z" clip-rule="evenodd"/><path d="M3.465 20.536C4.929 22 7.286 22 12 22s7.071 0 8.536-1.464C22 19.07 22 16.714 22 12c0-4.714 0-7.07-1.464-8.535L3.465 20.535Z" opacity=".5"/></g></svg>',
                          height: 30,
                          width: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () async {
              // hasStartedRecording = false;
              // pathToRecord = await noteRecorderController.stop();
              // controller.stop();
              //   },
              //   child: Container(
              //     alignment: Alignment.center,
              //     width: double.maxFinite,
              //     height: 50,
              //     margin: const EdgeInsets.only(top: 40),
              //     constraints: const BoxConstraints(maxWidth: 200),
              //     decoration: BoxDecoration(
              //         color: const Color(0xff6259FF),
              //         borderRadius: BorderRadius.circular(8)),
              //     child: const Text(
              //       "Stop Recording",
              //       style: TextStyle(
              //           fontSize: 18,
              //           color: Colors.white,
              //           fontWeight: FontWeight.w600,
              //           fontFamily: "Proxima Nova"),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
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
