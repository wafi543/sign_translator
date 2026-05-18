import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async'; // ✅ مهم جدًا

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  String text = "انتظر الإشارة...";
  bool isProcessing = false;
  Timer? timer; // ✅ متغير للتايمر
  final String apiBase =
      'https://api-sign-translator-481578818334.us-central1.run.app';

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<String> sendImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiBase}/predict'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    final json = jsonDecode(responseData);

    if (json["result"] == "no_hand") {
      return "ما فيه يد";
    }

    print(json);

    return json["result"];
  }

  Future<String> predict(List<double> landmarks) async {
    final res = await http.post(
      Uri.parse('${apiBase}/predict'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"landmarks": landmarks}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["result"];
    } else {
      return "error";
    }
  }

  String mapLetterToWord(String letter) {
    switch (letter) {
      case "MEEM":
        return "مرحبا";
      case "SHEEN":
        return "شكرا";
      case "NOON":
        return "نعم";
      case "LAAM":
        return "لا";
      case "KAAF":
        return "كيف حالك";
      default:
        return "...";
    }
  }

  void testApi() async {
    List<double> fake = List.generate(63, (i) => 0.5);

    String result = await predict(fake);

    setState(() {
      text = mapLetterToWord(result);
    });
  }

  void processFrame(CameraImage image) async {
    print("Frame received");
    if (isProcessing) return;

    isProcessing = true;

    print("Processing frame...");

    // هنا لاحقًا بنرسل للصورة لـ MediaPipe

    await Future.delayed(Duration(milliseconds: 300));

    isProcessing = false;
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await controller!.initialize();
    setState(() {});

    // await controller!.startImageStream((image) {
    //   processFrame(image);
    // });

    // 🔥 هنا تحط التايمر
    Timer.periodic(Duration(seconds: 1), (timer) async {
      final file = await controller!.takePicture();

      String letter = await sendImage(File(file.path));

      setState(() {
        text = mapLetterToWord(letter); // 🔥 مهم
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    timer?.cancel(); // تأكد من إلغاء التايمر
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
