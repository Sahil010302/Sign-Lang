import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_application_1/Login_SignIn/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9ca694),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              height: 500,
              width: 400,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/hello.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              '"Sign language is the noblest gift of silence."',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 253, 253, 253),
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Connecting people through the beauty of sign language",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 253, 253, 253),
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
