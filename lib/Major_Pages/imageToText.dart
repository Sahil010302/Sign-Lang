//single frame processing 
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/main.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart'; // Fix for MediaType

// class imageToText extends StatefulWidget {
//   const imageToText({super.key});

//   @override
//   State<imageToText> createState() => _imageToTextState();
// }

// class _imageToTextState extends State<imageToText> {
//   CameraController? cameraController;
//   String output = 'Waiting for prediction...';
//   bool isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     loadCamera();
//   }

//   void loadCamera() {
//     if (camera == null || camera!.isEmpty) {
//       print("No cameras found!");
//       return;
//     }
//     cameraController = CameraController(camera!.first, ResolutionPreset.medium);
//     cameraController!.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});

//       cameraController!.startImageStream((image) async {
//         if (!isProcessing) {
//           isProcessing = true;
//           await processAndSendImage(image);
//           isProcessing = false;
//         }
//       });
//     }).catchError((e) {
//       print("Camera initialization error: $e");
//     });
//   }

//   Future<void> processAndSendImage(CameraImage image) async {
//     try {
//       Uint8List jpegData = await _convertCameraImageToJpeg(image);
//       String base64Image = base64Encode(jpegData);

//       var response = await http.post(
//         Uri.parse("https://fyp-xqyx.onrender.com/predict"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"image": base64Image}),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         setState(() {
//           output = data["prediction"];
//         });
//       } else {
//         setState(() {
//           output = "Error: ${response.body}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         output = "Failed to process image";
//       });
//       print("Error: $e");
//     }
//   }

//   Future<Uint8List> _convertCameraImageToJpeg(CameraImage image) async {
//     return Uint8List.fromList(image.planes[0].bytes); // Placeholder
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Language Translator"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: cameraController == null || !cameraController!.value.isInitialized
//                 ? const Center(child: CircularProgressIndicator())
//                 : CameraPreview(cameraController!),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               output,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     cameraController?.dispose();
//     super.dispose();
//   }
// }


// above code but with some fixes for processing image
// This was the latest working code, on 31/3/25 at 1:08 AM  
// This code fucking works without errors

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/main.dart';
// import 'package:http/http.dart' as http;

// class imageToText extends StatefulWidget {
//   const imageToText({super.key});

//   @override
//   State<imageToText> createState() => _imageToTextState();
// }

// class _imageToTextState extends State<imageToText> {
//   CameraController? cameraController;
//   String output = 'Waiting for prediction...';
//   bool isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     loadCamera();
//   }

//   void loadCamera() {
//     if (camera == null || camera!.isEmpty) {
//       print("No cameras found!");
//       return;
//     }
//     cameraController = CameraController(camera!.first, ResolutionPreset.medium);
//     cameraController!.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});

//       // Start capturing frames continuously
//       captureFrame();
//     }).catchError((e) {
//       print("Camera initialization error: $e");
//     });
//   }

//   void captureFrame() async {
//     if (cameraController == null || !cameraController!.value.isInitialized || isProcessing) {
//       Future.delayed(const Duration(milliseconds: 300), captureFrame);
//       return;
//     }

//     isProcessing = true; // Prevent multiple simultaneous requests

//     try {
//       XFile imageFile = await cameraController!.takePicture();
//       Uint8List imageBytes = await imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);

//       await sendFrame(base64Image);
//     } catch (e) {
//       print("Error capturing frame: $e");
//     }

//     isProcessing = false;
//     Future.delayed(const Duration(milliseconds: 300), captureFrame); // Adjust timing if needed
//   }

//   Future<void> sendFrame(String base64Image) async {
//     try {
//       var response = await http.post(
//         Uri.parse("https://fyp-xqyx.onrender.com/predict"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"image": base64Image}),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         setState(() {
//           output = data["prediction"];
//         });
//       } else {
//         print("API Error: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       print("Error sending frame: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Language Translator"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: cameraController == null || !cameraController!.value.isInitialized
//                 ? const Center(child: CircularProgressIndicator())
//                 : CameraPreview(cameraController!),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               output,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     cameraController?.dispose();
//     super.dispose();
//   }
// }

// 500 ms, 30 frame processings , batch processing 
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_application_1/main.dart';

// class imageToText extends StatefulWidget {
//   const imageToText({super.key});

//   @override
//   State<imageToText> createState() => _imageToTextState();
// }

// class _imageToTextState extends State<imageToText> {
//   CameraController? cameraController;
//   String output = 'Waiting for prediction...';
//   bool isProcessing = false;
//   List<String> frameQueue = [];

//   @override
//   void initState() {
//     super.initState();
//     loadCamera();
//   }

//   void loadCamera() {
//     if (camera == null || camera!.isEmpty) {
//       print("No cameras found!");
//       return;
//     }
//     cameraController = CameraController(camera!.first, ResolutionPreset.medium);
//     cameraController!.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});

//       // Capture frame every 500ms
//       Future.delayed(Duration(milliseconds: 500), captureFrame);
//     }).catchError((e) {
//       print("Camera initialization error: $e");
//     });
//   }

//   void captureFrame() async {
//     if (cameraController == null || !cameraController!.value.isInitialized) return;

//     try {
//       XFile imageFile = await cameraController!.takePicture();
//       Uint8List imageBytes = await imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);

//       frameQueue.add(base64Image);
//       if (frameQueue.length >= 5) {  // Send batch of 5 frames
//         await processAndSendImages(frameQueue);
//         frameQueue.clear();
//       }
//     } catch (e) {
//       print("Error capturing frame: $e");
//     }

//     Future.delayed(Duration(milliseconds: 500), captureFrame);
//   }

//   Future<void> processAndSendImages(List<String> frames) async {
//     try {
//       var response = await http.post(
//         Uri.parse("https://fyp-xqyx.onrender.com/predict"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"frames": frames}),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         setState(() {
//           output = data["prediction"];
//         });
//       } else {
//         setState(() {
//           output = "Error: ${response.body}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         output = "Failed to process image";
//       });
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Language Translator"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: cameraController == null || !cameraController!.value.isInitialized
//                 ? const Center(child: CircularProgressIndicator())
//                 : CameraPreview(cameraController!),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               output,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     cameraController?.dispose();
//     super.dispose();
//   }
// }


// working Test.py ke basis pe yeh code gpt ne likha hai
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_application_1/main.dart';

// class imageToText extends StatefulWidget {
//   const imageToText({super.key});

//   @override
//   State<imageToText> createState() => _imageToTextState();
// }

// class _imageToTextState extends State<imageToText> {
//   CameraController? cameraController;
//   String output = 'Waiting for prediction...';
//   bool isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     loadCamera();
//   }

//   void loadCamera() {
//     if (camera == null || camera!.isEmpty) {
//       print("No cameras found!");
//       return;
//     }
//     cameraController = CameraController(camera!.first, ResolutionPreset.medium);
//     cameraController!.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});

//       // Capture frames continuously every 300ms
//       captureFrame();
//     }).catchError((e) {
//       print("Camera initialization error: $e");
//     });
//   }

//   void captureFrame() async {
//     if (cameraController == null || !cameraController!.value.isInitialized || isProcessing) {
//       Future.delayed(Duration(milliseconds: 300), captureFrame);
//       return;
//     }

//     isProcessing = true; // Prevent multiple simultaneous requests

//     try {
//       XFile imageFile = await cameraController!.takePicture();
//       Uint8List imageBytes = await imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);

//       await sendFrame(base64Image);
//     } catch (e) {
//       print("Error capturing frame: $e");
//     }

//     isProcessing = false;
//     Future.delayed(Duration(milliseconds: 300), captureFrame); // Adjust for smooth processing
//   }

//   Future<void> sendFrame(String base64Image) async {
//     try {
//       var response = await http.post(
//         Uri.parse("https://fyp-xqyx.onrender.com/predict"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"image": base64Image}),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         setState(() {
//           output = data["prediction"];
//         });
//       } else {
//         print("API Error: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       print("Error sending frame: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Language Translator"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: cameraController == null || !cameraController!.value.isInitialized
//                 ? const Center(child: CircularProgressIndicator())
//                 : CameraPreview(cameraController!),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               output,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     cameraController?.dispose();
//     super.dispose();
//   }
// }


// Code is based on Test.py which was tested on hosted Hugging faces code
// lesssgo bouyyyyy
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
  List<String> frameQueue = []; // Store last 30 frames
  Queue<String> sentenceQueue = Queue(); // Store last 5 words for sentence
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
    cameraController = CameraController(camera!.first, ResolutionPreset.medium); //  before ResolutionPreset.medium 
    cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      captureFrame(); // Start frame capturing
    }).catchError((e) {
      print("Camera initialization error: $e");
    });
  }

  void captureFrame() async {
    if (cameraController == null || !cameraController!.value.isInitialized || isProcessing) {
      Future.delayed(const Duration(milliseconds: 100), captureFrame);
      return;
    }

    try {
      XFile imageFile = await cameraController!.takePicture();
      Uint8List imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Store latest 30 frames
      frameQueue.add("data:image/jpeg;base64,$base64Image");
      if (frameQueue.length > maxFrames) {
        frameQueue.removeAt(0);
      }

      if (frameQueue.length == maxFrames) {
        await sendFrames(); // Send only when we have 30 frames
      }
    } catch (e) {
      print("Error capturing frame: $e");
    }

    Future.delayed(const Duration(milliseconds: 100), captureFrame); // Continuous capturing
  }

  Future<void> sendFrames() async {
    if (isProcessing) return; // Avoid multiple requests at the same time
    isProcessing = true;

    try {
      String apiUrl = "https://rohitParkhe-sign-language-api.hf.space/predict";
      Map<String, dynamic> payload = {"images": frameQueue}; // Send list of 30 frames
      String jsonPayload = jsonEncode(payload);

      print("Sending payload with ${frameQueue.length} frames...");

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonPayload,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double confidence = data['confidence'] ?? 0;
        String prediction = data['prediction'] ?? '';

        // Update sentence only if confidence is high and word is not repeating
        if (prediction.isNotEmpty && confidence > 0.8) {
          if (sentenceQueue.isEmpty || sentenceQueue.last != prediction) {
            if (sentenceQueue.length >= maxWords) {
              sentenceQueue.removeFirst(); // Keep only last 5 words
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Language Translator"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: cameraController == null || !cameraController!.value.isInitialized
          //       ? const Center(child: CircularProgressIndicator())
          //       : CameraPreview(cameraController!),
          // ),
          Container(
  child: cameraController == null || !cameraController!.value.isInitialized
      ? const Center(child: CircularProgressIndicator())
      : AspectRatio(
          aspectRatio: 4 / 3,  // Ensures correct frame size
          child: CameraPreview(cameraController!),
        ),
),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              outputSentence,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
