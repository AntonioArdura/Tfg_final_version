import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:tfg_v1/controllers/EmotionsFunctions.dart';
import 'package:tfg_v1/models/AuthorizationModel.dart';

import 'package:tfg_v1/models/BbddBox.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:tfg_v1/views/SplashScreen.dart';
import 'package:tfg_v1/views/CalendarSummaryScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BoxAdapter());
  await openMainBox();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // Establecer el tema como oscuro
        //scaffoldBackgroundColor: Color.fromARGB(
        //  87, 27, 159, 180),
        primaryColor: Colors.blueGrey[800], // Color primario oscuro
        highlightColor: Colors.white, // Color de acento claro
      ),
      home: SplashScreen(),
    );
  }
}
