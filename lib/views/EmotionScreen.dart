import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tfg_v1/views/LifeAreaScreen.dart';
import 'WeeklyScreen.dart';
import 'package:tfg_v1/models/moodVariables.dart';
import 'package:tfg_v1/models/BbddBox.dart';

class EmotionScreen extends StatefulWidget {
  @override
  ImageCarousel createState() => ImageCarousel();
}

// String calcularDiaSemana(DateTime fecha) {
//   final formato = DateFormat('EEEE');
//   return formato.format(fecha);
// }

class ImageCarousel extends State<EmotionScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CarouselSlider.builder(
          options: CarouselOptions(
            height: (MediaQuery.of(context).size.height),
            viewportFraction: BorderSide.strokeAlignOutside,
          ),
          itemCount: emotionImages.length,
          itemBuilder: (context, index, realIndex) {
            final feel = feeling[index];
            final emotionImage = emotionImages[feel];
            final colorFondo = colores[feel];

            //String formattedDate = formatter.format(now);
            return buildImage(emotionImage!, index, colorFondo!, feel, context);
          },
        ),
      );

  Widget buildImage(String emotionImage, int index, Color colores, String feel,
          BuildContext context) =>
      Container(
          decoration: BoxDecoration(color: colores),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Text(
                      'HOW ARE YOU FEELING TODAY?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RubikOne',
                          fontSize: 30,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    )),
                Column(children: [
                  Text(
                    feel,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  Hero(
                      tag: 'selectEmotion',
                      child: Image.asset(emotionImage, scale: 2.5)),
                ]),
                SizedBox(
                    height: 40,
                    width: 150,
                    child: Hero(
                        tag: 'lifeArea',
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    reverseTransitionDuration:
                                        const Duration(seconds: 1),
                                    pageBuilder: (context, animation, _) {
                                      return FadeTransition(
                                          opacity: animation,
                                          child: LifeAreaPage(
                                              feel: feel, day: DateTime.now()));
                                    }),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              side: const BorderSide(width: 1.0),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('This is my mood',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))))
              ])));
  Future<Uint8List> getImageBytes(String imagePath) async {
    // Leer la imagen como bytes
    final bytes = await rootBundle.load(imagePath);
    // Convertir los bytes en una lista de enteros sin signo
    final uint8list = bytes.buffer.asUint8List();
    return uint8list;
  }
}
