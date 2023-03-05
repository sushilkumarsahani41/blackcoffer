import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.filePath});
  // ignore: empty_constructor_bodies
  final String filePath;
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final storage = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final file = File(widget.filePath);
            final videosRef = storage.child('videos');
            await videosRef.putFile(file);
            // ignore: empty_catches
            try {} on FirebaseException {}
          },
          child: Text("Upload"),
        ),
      ),
    );
  }
}
