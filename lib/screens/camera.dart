import 'dart:io';

import 'package:blackcoffer/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(MyApp.allcameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // final Directory appDirectory = await getApplicationDocumentsDirectory();
  // ignore: non_constant_identifier_names
  bool flash_on = false;
  bool isRecoding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: CameraPreview(_cameraController),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isRecoding
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.redAccent,
                                width: 6,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: IconButton(
                                iconSize: 40,
                                icon: const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  final file = await _cameraController
                                      .stopVideoRecording();
                                  setState(() => isRecoding = !isRecoding);
                                  final route = MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) =>
                                        CameraView(filePath: file.path),
                                  );
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(context, route);
                                },
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 6,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: IconButton(
                                iconSize: 40,
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _cameraController.startVideoRecording();
                                  setState(() {
                                    isRecoding = !isRecoding;
                                  });
                                },
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ])
          ],
        ),
      ],
    ));
  }
}

class CameraView extends StatefulWidget {
  const CameraView({super.key, required this.filePath});
  final String filePath;
  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.filePath));
    _videoController.setLooping(false);
    _videoController.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  bool isplaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          VideoPlayer(_videoController),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isplaying
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 6,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              iconSize: 40,
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _videoController.play();
                                setState(() {
                                  setState(() {
                                    isplaying = true;
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
