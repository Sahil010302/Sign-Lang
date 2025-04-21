import 'package:flutter/material.dart';
import 'package:flutter_application_1/Major_Pages/guide.dart';
import 'package:flutter_application_1/Major_Pages/imageToText.dart';
import 'package:flutter_application_1/Major_Pages/textToSpeech.dart';
import 'package:flutter_application_1/Major_Pages/textToSign.dart';
import 'package:flutter_application_1/Major_Pages/speechToSign.dart';
import 'package:flutter_application_1/const.dart';

class Sections extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget pageToNavigate;
  final Color cardColor;
  final Color buttonColor;
  final Color textColor;
  final String imagePath; // NEW: path to image

  const Sections({
    super.key,
    required this.title,
    required this.icon,
    required this.pageToNavigate,
    required this.cardColor,
    required this.buttonColor,
    required this.textColor,
    required this.imagePath, // NEW
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 30, color: textColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 15), // spacing between title and image+button
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0, right: 20),
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
                        backgroundColor: Color.fromARGB(255, 183, 192, 176),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: secondaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Stack(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/images/user.avif'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Sahil Dongre',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'sahildongre1006@gmail.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        // You can navigate to an edit page here
                        print("Edit the profile");
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Sections(
                title: "Guide",
                icon: Icons.book,
                pageToNavigate: Guide(),
                cardColor: cardColor,
                buttonColor: secondaryColor,
                textColor: Colors.white,
                imagePath: "assets/images/guide.jpg",
              ),
              Sections(
                title: "Text To Speech",
                icon: Icons.record_voice_over,
                pageToNavigate: Text_To_Speech(),
                cardColor: cardColor,
                buttonColor: secondaryColor,
                textColor: Colors.white,
                imagePath: "assets/images/textToSpeech.avif",
              ),
              Sections(
                title: "Hand Sign Recognition",
                icon: Icons.pan_tool_alt,
                pageToNavigate: imageToText(),
                cardColor: cardColor,
                buttonColor: secondaryColor,
                textColor: Colors.white,
                imagePath: "assets/images/handSign.jpg",
              ),
              Sections(
                title: "Speech To Sign",
                icon: Icons.hearing,
                pageToNavigate: SpeechScreen(),
                cardColor: cardColor,
                buttonColor: secondaryColor,
                textColor: Colors.white,
                imagePath: "assets/images/speechToText.png",
              ),
              Sections(
                title: "Text To Sign",
                icon: Icons.text_fields,
                pageToNavigate: TextToSignPage(),
                cardColor: cardColor,
                buttonColor: secondaryColor,
                textColor: Colors.white,
                imagePath: "assets/images/textToSign.jpg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
