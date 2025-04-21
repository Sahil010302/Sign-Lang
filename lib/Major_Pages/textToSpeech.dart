import 'package:flutter/material.dart';
import 'package:flutter_application_1/const.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Text_To_Speech extends StatefulWidget {
  const Text_To_Speech({super.key});

  @override
  State<Text_To_Speech> createState() => _Text_To_SpeechState();
}

class _Text_To_SpeechState extends State<Text_To_Speech> {
  final FlutterTts tts = FlutterTts();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFcad2c5), // Background color from your theme
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Text To Speech",
          style: appbarStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image on top
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/textToSpeech2.avif', // make sure this exists
                height: 290,
                width: 390,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Text input
            TextField(
              maxLength: 500,
              maxLines: 5,
              controller: textEditingController,
              decoration: const InputDecoration(
                hintText: "Enter the text ...",
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(color: bgColor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Speech button
            GestureDetector(
              onTap: () {
                speak(textEditingController.text);
              },
              child: Container(
                height: 55,
                width: 180,
                decoration: BoxDecoration(
                    color: cardColor, // consistent color
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey)),
                child: const Center(
                  child: Text(
                    "Speak",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1);
    await tts.speak(text);
  }
}
