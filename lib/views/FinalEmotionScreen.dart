import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tfg_v1/controllers/EmotionsFunctions.dart';
import 'package:tfg_v1/views/LoadingRecomendationScreen.dart';
import '../models/PlaylistAndSong.dart';
import 'package:tfg_v1/models/moodVariables.dart';

import 'package:tfg_v1/repository/repository.dart';
import 'package:tfg_v1/views/HomeScreen.dart';
//import 'package:tfg_v1/views/Summary.dart';

class FinalEmotionScreen extends StatefulWidget {
  final String initialfeel;

  const FinalEmotionScreen({required this.initialfeel});
  @override
  FinalEmotionScreenState createState() => FinalEmotionScreenState();
}

// String calcularDiaSemana(DateTime fecha) {
//   final formato = DateFormat('EEEE');
//   return formato.format(fecha);
// }

class FinalEmotionScreenState extends State<FinalEmotionScreen> {
  bool isLoading = false;
  String _selectedFeeling = '';
  final _apiProvider = SpotifyApiProviderList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Hero(tag: 'goal', child: Text('HOW DO YOU WANT TO FEEL?'))),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[800],
        toolbarHeight: 45,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: feeling.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Cantidad de columnas
                childAspectRatio: 1, // Relación de aspecto de las tarjetas
              ),
              itemBuilder: (BuildContext context, int index) {
                final feel = feeling[index];
                final feelImage = emotionImages[feel];
                final feelColor = colores[feel];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFeeling = feel;
                    });
                  },
                  child: Card(
                    color: _selectedFeeling == feel
                        ? feelColor!.withOpacity(0.8)
                        : Colors.white,
                    child: Container(
                      height: 150,
                      child: Column(
                        children: [
                          SizedBox(height: 35),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset(
                                feelImage!,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                feel,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedFeeling == feel
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 1),
            child: TextButton(
              onPressed: _selectedFeeling == null || _selectedFeeling == ''
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true; // Activar la pantalla de carga
                      });

                      camino = obtenerCaminoOptimo(
                          _selectedFeeling, widget.initialfeel);
                      musicVariables = progressiveChangesOnPath(camino);

                      // Navegar a la pantalla de carga
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingRecommendationScreen(),
                        ),
                      );

                      songsRecommendation = await _apiProvider
                          .getSpotifyRecommendations(musicVariables);

                      setState(() {
                        isLoading = false; // Desactivar la pantalla de carga
                      });

                      // Navegar a SongListPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongListPage(),
                        ),
                      );
                    },
              child: Text(
                'Generate Playlist',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Color.fromARGB(198, 20, 163, 185);
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(150, 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
