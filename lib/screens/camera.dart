import 'package:blackcoffer/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
            Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isRecoding
                        ? IconButton(
                            onPressed: () async {
                              // ignore: unused_local_variable
                              XFile video =
                                  await _cameraController.stopVideoRecording();
                              setState(() {
                                isRecoding = !isRecoding;
                              });
                            },
                            icon: const Icon(
                              Icons.pause_circle,
                              size: 50,
                              color: Colors.blue,
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.play_circle,
                              size: 50,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              _cameraController.startVideoRecording();
                              setState(() {
                                isRecoding = !isRecoding;
                              });
                            },
                          )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    ));
  }
}
