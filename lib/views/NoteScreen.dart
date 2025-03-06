import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/models/PlaylistAndSong.dart';
import 'package:tfg_v1/repository/repository.dart';
import 'package:tfg_v1/views/FinalEmotion.dart';
import 'package:tfg_v1/views/FinalEmotionScreen.dart';
import 'package:tfg_v1/views/HomeScreen.dart';
//import 'package:tfg_v1/views/Summary.dart';
import 'package:tfg_v1/views/WeeklyScreen.dart';

class DiaryScreen extends StatefulWidget {
  final String feel;
  final DateTime day;
  //final Uint8List image;
  final String area;

  const DiaryScreen(
      {required this.feel,
      required this.day,
      //required this.color,
      //required this.image,
      required this.area});
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

final emotionsBox = Hive.box<BbddBox>('main');
void saveEmotion(String emotionName, DateTime date, String area,
    String dairyDescription, String dairyText) {
  final emotion = BbddBox(
      date, emotionName, area, dairyDescription, dairyText, 0.0, 0.0, 0.0, 0.0);
  emotionsBox.put('$date', emotion);
}

class _DiaryScreenState extends State<DiaryScreen> {
  //final _apiProvider = SpotifyApiProviderList();
  final _descriptionController = TextEditingController();
  final _diaryController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Hero(tag: 'notes', child: Text('Add a note'))),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey[800],
          toolbarHeight: 45,
        ),
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _descriptionController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Add a brief description...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _diaryController,
                        style: TextStyle(color: Colors.black),
                        minLines: 8,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Write a mini diary of what happened...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 1),
            child: Hero(
                tag: 'goal',
                child: TextButton(
                  onPressed: () async {
                    // songsRecommendation = await _apiProvider
                    //     .getSpotifyRecommendations(geners[widget.feel]!);
                    saveEmotion(widget.feel, widget.day, widget.area,
                        _descriptionController.text, _diaryController.text);
                    Navigator.of(context).push(
                      PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 1),
                          reverseTransitionDuration: const Duration(seconds: 1),
                          pageBuilder: (context, animation, _) {
                            return FadeTransition(
                              opacity: animation,
                              child:
                                  FinalEmotionScreen(initialfeel: widget.feel),
                            );
                          }),
                    );
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20.0,
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
                )),
          ),
        ]));
  }
}
