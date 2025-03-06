import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tfg_v1/controllers/EmotionsFunctions.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/views/WaitingScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Fondo de la pantalla
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/blueMoveCircle.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('lib/assets/Logo.png', scale: 3),
                SizedBox(
                  height: 60,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () async {
                      // await openMainBox();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => WaitScreen()),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF1DB954),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      side: BorderSide(
                        width: 0.0,
                        color: Color(0xFF1DB954),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Sign In with Spotify",
                            style: TextStyle(
                              fontSize: 11.0,
                              fontFamily: "Raleway",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Icon(FontAwesomeIcons.spotify, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
