// old UI Made by Dongre

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_application_1/Major_Pages/imageToText.dart';
// import 'package:flutter_application_1/Major_Pages/textToSpeech.dart';
// import 'package:flutter_application_1/Major_Pages/textToSign.dart';
// import 'package:flutter_application_1/Major_Pages/speechToSign.dart';
// import 'package:flutter_application_1/const.dart';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: bgColor,
//         title: const Text(
//           "Home",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const Sections(
//               title: "Text To Speech",
//               pageToNavigate: Text_To_Speech(),
//             ),
//             const Sections(
//               title: "Hand Sign",
//               pageToNavigate: imageToText(),
//             ),
//             const Sections(
//               title: "Speech to Sing",
//               pageToNavigate: SpeechScreen(),
//             ),
//             Sections(
//               title: "Text to Sign",
//               pageToNavigate: TextToSignPage(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Main Containers aahet home page che j major features dakhav nar konte aahe aani
// //click var te main page var gheun janar - okay 😁

// class Sections extends StatelessWidget {
//   final String title;
//   final Widget pageToNavigate;

//   const Sections({
//     super.key,
//     required this.title,
//     required this.pageToNavigate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(15),
//       height: 200,
//       width: double.maxFinite,
//       decoration: const BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.all(
//           Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 25,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 8.0, top: 90),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => pageToNavigate,
//                       ),
//                     );
//                   },
//                   child: Container(
//                     height: 40,
//                     width: 80,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.white,
//                       ),
//                       color: Colors.black38,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         "Click Here",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }


// Sundar UI

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Major_Pages/imageToText.dart';
import 'package:flutter_application_1/Major_Pages/textToSpeech.dart';
import 'package:flutter_application_1/Major_Pages/textToSign.dart';
import 'package:flutter_application_1/Major_Pages/speechToSign.dart';
import 'package:flutter_application_1/const.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 61, 103, 150)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Sections(
                title: "Text To Speech",
                icon: Icons.record_voice_over,
                pageToNavigate: Text_To_Speech(),
              ),
              const Sections(
                title: "Hand Sign Recognition",
                icon: Icons.pan_tool_alt,
                pageToNavigate: imageToText(),
              ),
              const Sections(
                title: "Speech To Sign",
                icon: Icons.hearing,
                pageToNavigate: SpeechScreen(),
              ),
              Sections(
                title: "Text To Sign",
                icon: Icons.text_fields,
                pageToNavigate: TextToSignPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Sections extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget pageToNavigate;

  const Sections({
    super.key,
    required this.title,
    required this.icon,
    required this.pageToNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Color.fromARGB(255, 20, 40, 80),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 160,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => pageToNavigate,
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  label: const Text("Start"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: bgColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
