import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/const.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Text_To_Speech extends StatefulWidget {
  const Text_To_Speech({super.key});

  @override
  State<Text_To_Speech> createState() => _Text_To_SpeechState();
}

class _Text_To_SpeechState extends State<Text_To_Speech> {
  final FlutterTts tts = FlutterTts();
  TextEditingController TextEditingontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          "Text To Speech",
          style: appbarStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 500,
              maxLines: 5,
              controller: TextEditingontroller,
              decoration: const InputDecoration(
                hintText: "Enter the text ...",
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
          ),
          GestureDetector(
            onTap: () {
              print(TextEditingontroller.text);
              speak(TextEditingontroller.text);
            },
            child: Container(
              height: 45,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  "Speech",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1);
    await tts.speak(text);
  }
}
