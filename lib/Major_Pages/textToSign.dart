import 'package:flutter/material.dart';
import 'package:flutter_application_1/Major_Pages/utils.dart' as utils;

class TextToSignPage extends StatefulWidget {
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
          _state += 1;
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
              _state += 1;
              _displaytext += char;
              _path = "assets/letters/";
              _img = char;
              _ext = ".png";
            });
            await Future.delayed(Duration(milliseconds: 1500));
          } else {
            setState(() {
              _state += 1;
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
        _state += 1;
        _displaytext += " ";
        _path = "assets/letters/";
        _img = "space";
        _ext = ".png";
      });
      await Future.delayed(Duration(milliseconds: 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text to Sign Language")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: "Type your message",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (text) {
                  processTextToSignLanguage(text);
                },
              ),
              SizedBox(height: 20),
              Text(
                "Sign Language Output:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Image(
                  image: AssetImage('$_path$_img$_ext'),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  key: ValueKey<int>(_state),
                  width: MediaQuery.of(context).size.width,
                  height: (4 / 3) * MediaQuery.of(context).size.width,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
