import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_application_1/Major_Pages/utils.dart' as utils;
import 'package:flutter_application_1/Major_Pages/textToSign.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/const.dart'; // Assuming color/theme constants

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  String _img = 'space';
  String _ext = '.png';
  String _path = 'assets/letters/';
  String _displaytext = 'Press the button and start speaking';
  int _state = 0;

  String _selectedLanguage = 'English';
  bool _showLanguageDropdown = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        title: const Text(
          'Sanket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset("assets/logo/sanket_icon.png"),
        // ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _text = '';
            _path = 'assets/letters/';
            _img = 'space';
            _ext = '.png';
            _displaytext = 'Press the button and start speaking...';
            _state = 0;
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Image.asset(
                  '$_path$_img$_ext',
                  fit: BoxFit.contain,
                  key: ValueKey<int>(_state),
                  width: MediaQuery.of(context).size.width,
                  height: (4 / 3) * MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                  thickness: 1.5,
                  color: Colors.black45,
                  indent: 20,
                  endIndent: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  _displaytext,
                  style: const TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
              if (_showLanguageDropdown)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: ['English', 'Hindi', 'Marathi']
                        .map((lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                  ),
                ),
              const Divider(
                thickness: 1.5,
                color: Colors.black54,
                indent: 20,
                endIndent: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TextToSignPage()),
              );
            },
            child: Icon(Icons.mode_edit_outline_outlined),
            foregroundColor: Colors.white,
          ),
          AvatarGlow(
            animate: _isListening,
            glowColor: primaryColor,
            endRadius: 75.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              foregroundColor: Colors.white,
            ),
          ),
          FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              setState(() {
                _showLanguageDropdown = !_showLanguageDropdown;
              });
            },
            child: const Icon(Icons.g_translate),
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      await translation(_text);
    }
  }

  Future<void> translation(String originalText) async {
    setState(() {
      _displaytext = '';
    });

    String processedText = originalText.toLowerCase();
    String displayText = processedText;

    if (_selectedLanguage == 'Hindi' || _selectedLanguage == 'Marathi') {
      displayText = processedText;
      processedText =
          await translateToEnglish(processedText, _selectedLanguage);
    }

    setState(() {
      _displaytext = displayText;
    });

    List<String> strArray = processedText.split(" ");
    for (String content in strArray) {
      if (utils.words.contains(content)) {
        String file = content;
        int idx = utils.words.indexOf(content);
        int _duration = int.parse(utils.words.elementAt(idx + 1));
        setState(() {
          _state++;
          _path = 'assets/ISL_Gifs/';
          _img = file;
          _ext = '.gif';
        });
        await Future.delayed(Duration(milliseconds: _duration));
      } else {
        for (var i = 0; i < content.length; i++) {
          if (utils.letters.contains(content[i])) {
            String char = content[i];
            setState(() {
              _state++;
              _path = 'assets/letters/';
              _img = char;
              _ext = '.png';
            });
            await Future.delayed(const Duration(milliseconds: 1500));
          } else {
            setState(() {
              _state++;
              _path = 'assets/letters/';
              _img = 'space';
              _ext = '.png';
            });
            await Future.delayed(const Duration(milliseconds: 1000));
          }
        }
      }
      setState(() {
        _state++;
        _path = 'assets/letters/';
        _img = 'space';
        _ext = '.png';
      });
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  Future<String> translateToEnglish(
      String input, String selectedLanguage) async {
    final Map<String, String> languageCodes = {
      'English': 'en',
      'Hindi': 'hi',
      'Marathi': 'mr',
    };

    final String sourceLang = languageCodes[selectedLanguage] ?? 'en';

    final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?key=AIzaSyDiWbNGn_oUfZwa-7OJWn96MIW8IrDK_I4',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'q': input,
        'source': sourceLang,
        'target': 'en',
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      print("Translation failed: ${response.body}");
      return input;
    }
  }
}
