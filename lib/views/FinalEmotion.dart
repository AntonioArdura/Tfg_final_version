// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:tfg_v1/controllers/EmotionsFunctions.dart';
// import 'package:tfg_v1/views/LoadingRecomendationScreen.dart';
// import '../models/PlaylistAndSong.dart';
// import 'package:tfg_v1/models/moodVariables.dart';

// import 'package:tfg_v1/repository/repository.dart';
// import 'package:tfg_v1/views/HomeScreen.dart';
// //import 'package:tfg_v1/views/Summary.dart';

// class FinalEmotion extends StatefulWidget {
//   final String initialfeel;

//   const FinalEmotion({required this.initialfeel});
//   @override
//   FinalEmotionState createState() => FinalEmotionState();
// }

// // String calcularDiaSemana(DateTime fecha) {
// //   final formato = DateFormat('EEEE');
// //   return formato.format(fecha);
// // }

// class FinalEmotionState extends State<FinalEmotion> {
//   bool isLoading = false;
//   final _apiProvider = SpotifyApiProviderList();
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: CarouselSlider.builder(
//           options: CarouselOptions(
//             height: (MediaQuery.of(context).size.height),
//             viewportFraction: BorderSide.strokeAlignOutside,
//           ),
//           itemCount: emotionImages.length,
//           itemBuilder: (context, index, realIndex) {
//             final emotionImage = emotionImages[index];
//             final colorFondo = colores[index];
//             final feel = feeling[index];
//             //String formattedDate = formatter.format(now);
//             return buildImage(emotionImage, index, colorFondo, feel, context);
//           },
//         ),
//       );

//   Widget buildImage(String emotionImage, int index, Color colores, String feel,
//           BuildContext context) =>
//       Container(
//           decoration: BoxDecoration(color: colores),
//           child: Center(
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                 const Padding(
//                     padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
//                     child: Text(
//                       'HOW DO YOU WANT TO FEEL?',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'RubikOne',
//                           fontSize: 30,
//                           color: Colors.black87),
//                       textAlign: TextAlign.center,
//                     )),
//                 Column(children: [
//                   Text(
//                     feel,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w600, color: Colors.black87),
//                   ),
//                   Image.asset(emotionImage, scale: 2.5),
//                 ]),
//                 SizedBox(
//                   height: 40,
//                   width: 150,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       setState(() {
//                         isLoading = true; // Activar la pantalla de carga
//                       });

//                       camino = obtenerCaminoOptimo(feel, widget.initialfeel);
//                       musicVariables = progressiveChangesOnPath(camino);

//                       // Navegar a la pantalla de carga
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => LoadingRecommendationScreen(),
//                         ),
//                       );

//                       songsRecommendation = await _apiProvider
//                           .getSpotifyRecommendations(musicVariables);

//                       setState(() {
//                         isLoading = false; // Desactivar la pantalla de carga
//                       });

//                       // Navegar a SongListPage
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SongListPage(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: const StadiumBorder(),
//                       side: const BorderSide(width: 1.0),
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: Text(
//                       'Finish',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ])));
//   Future<Uint8List> getImageBytes(String imagePath) async {
//     // Leer la imagen como bytes
//     final bytes = await rootBundle.load(imagePath);
//     // Convertir los bytes en una lista de enteros sin signo
//     final uint8list = bytes.buffer.asUint8List();
//     return uint8list;
//   }
// }
