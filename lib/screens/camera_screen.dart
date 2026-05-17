import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  String text = "انتظر الإشارة...";
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    void processFrame(CameraImage image) async {
      print("Frame received");
      if (isProcessing) return;

      isProcessing = true;

      print("Processing frame...");

      // هنا لاحقًا بنرسل للصورة لـ MediaPipe

      await Future.delayed(Duration(milliseconds: 300));

      isProcessing = false;
    }

    await controller!.initialize();
    setState(() {});

    await controller!.startImageStream((image) {
      processFrame(image);
    });
  }
  

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.7),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {
                  text = "تم المسح";
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
