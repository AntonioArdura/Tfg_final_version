import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_v1/controllers/Logout.dart';
import 'package:tfg_v1/views/EmotionScreen.dart';
import 'package:tfg_v1/views/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shared_Preferences();
  }

  void shared_Preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('logged');
    print("LOGGED: ${logged}");
    if (logged == true && logged != null) {
      Timer(
          Duration(seconds: 5),
          () => Navigator.push(context,
              MaterialPageRoute(builder: ((context) => EmotionScreen()))));
    } else {
      Timer(
          Duration(seconds: 5),
          () => Navigator.push(context,
              MaterialPageRoute(builder: ((context) => LoginScreen()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Container(
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "MoodBalance",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: Colors.black,
                    indent: 40,
                    endIndent: 40,
                  ),
                  Text(
                    "Antonio Ardura",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
