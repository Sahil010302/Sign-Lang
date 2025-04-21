import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;
import 'dart:collection';

class imageToText extends StatefulWidget {
  const imageToText({super.key});

  @override
  State<imageToText> createState() => _imageToTextState();
}

class _imageToTextState extends State<imageToText> {
  CameraController? cameraController;
  List<String> frameQueue = [];
  Queue<String> sentenceQueue = Queue();
  String outputSentence = 'Waiting for prediction...';
  bool isProcessing = false;
  final int maxFrames = 30;
  final int maxWords = 5;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  void loadCamera() {
    if (camera == null || camera!.isEmpty) {
      print("No cameras found!");
      return;
    }
    cameraController = CameraController(camera!.first, ResolutionPreset.medium);
    cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      captureFrame();
    }).catchError((e) {
      print("Camera initialization error: $e");
    });
  }

  void captureFrame() async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized ||
        isProcessing) {
      Future.delayed(const Duration(milliseconds: 100), captureFrame);
      return;
    }

    try {
      XFile imageFile = await cameraController!.takePicture();
      Uint8List imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      frameQueue.add("data:image/jpeg;base64,$base64Image");
      if (frameQueue.length > maxFrames) {
        frameQueue.removeAt(0);
      }

      if (frameQueue.length == maxFrames) {
        await sendFrames();
      }
    } catch (e) {
      print("Error capturing frame: $e");
    }

    Future.delayed(const Duration(milliseconds: 100), captureFrame);
  }

  Future<void> sendFrames() async {
    if (isProcessing) return;
    isProcessing = true;

    try {
      String apiUrl = "https://rohitParkhe-sign-language-api.hf.space/predict";
      Map<String, dynamic> payload = {"images": frameQueue};
      String jsonPayload = jsonEncode(payload);

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonPayload,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double confidence = data['confidence'] ?? 0;
        String prediction = data['prediction'] ?? '';

        if (prediction.isNotEmpty && confidence > 0.8) {
          if (sentenceQueue.isEmpty || sentenceQueue.last != prediction) {
            if (sentenceQueue.length >= maxWords) {
              sentenceQueue.removeFirst();
            }
            sentenceQueue.add(prediction);
          }
        }

        setState(() {
          outputSentence = sentenceQueue.join(" ");
        });
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error sending frames: $e");
    }

    isProcessing = false;
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        title: const Text(
          "Sanket",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset("assets/logo/sanket_icon.png"),
        // ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: cameraController == null ||
                    !cameraController!.value.isInitialized
                ? const Center(child: CircularProgressIndicator())
                : AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CameraPreview(cameraController!),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                outputSentence,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
