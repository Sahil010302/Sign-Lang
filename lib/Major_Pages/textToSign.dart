import 'package:flutter/material.dart';
import 'package:flutter_application_1/Major_Pages/utils.dart' as utils;
import 'package:flutter_application_1/const.dart'; // For primaryColor, secondaryColor

class TextToSignPage extends StatefulWidget {
  const TextToSignPage({Key? key}) : super(key: key);

  @override
  _TextToSignPageState createState() => _TextToSignPageState();
}

class _TextToSignPageState extends State<TextToSignPage> {
  TextEditingController _textController = TextEditingController();
  String _displaytext = "Enter text to convert to sign language";
  String _img = "space";
  String _ext = ".png";
  String _path = "assets/letters/";
  int _state = 0;

  void processTextToSignLanguage(String text) async {
    setState(() {
      _displaytext = "";
    });

    String inputText = text.toLowerCase();
    List<String> words = inputText.split(" ");

    for (String word in words) {
      if (utils.words.contains(word)) {
        String file = word;
        int idx = utils.words.indexOf(word);
        int duration = int.parse(utils.words.elementAt(idx + 1));
        setState(() {
          _state++;
          _displaytext += word;
          _path = "assets/ISL_Gifs/";
          _img = file;
          _ext = ".gif";
        });
        await Future.delayed(Duration(milliseconds: duration));
      } else {
        for (var i = 0; i < word.length; i++) {
          if (utils.letters.contains(word[i])) {
            String char = word[i];
            setState(() {
              _state++;
              _displaytext += char;
              _path = "assets/letters/";
              _img = char;
              _ext = ".png";
            });
            await Future.delayed(Duration(milliseconds: 1500));
          } else {
            setState(() {
              _state++;
              _displaytext += word[i];
              _path = "assets/letters/";
              _img = "space";
              _ext = ".png";
            });
            await Future.delayed(Duration(milliseconds: 1000));
          }
        }
      }
      setState(() {
        _state++;
        _displaytext += " ";
        _path = "assets/letters/";
        _img = "space";
        _ext = ".png";
      });
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
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
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign Language Output:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    '$_path$_img$_ext',
                    key: ValueKey<int>(_state),
                    width: MediaQuery.of(context).size.width,
                    height: (4 / 3) * MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _displaytext,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 120,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: "Type your message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (text) {
                      processTextToSignLanguage(text);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    processTextToSignLanguage(_textController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
