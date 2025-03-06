import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tfg_v1/controllers/Logout.dart';
import 'package:tfg_v1/controllers/WeeklyFunctions.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/models/PlaylistAndSong.dart';
import 'package:tfg_v1/models/navBar.dart';
import 'package:tfg_v1/views/CalendarSummaryScreen.dart';
import 'package:tfg_v1/views/EmotionScreen.dart';
import 'package:tfg_v1/views/HomeScreen.dart';
import 'package:tfg_v1/views/MyPlaylists.dart';
import 'package:tfg_v1/views/NoteScreen.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String subject, String body) async {
  String username = 'supersexidelegado@gmail.com';
  String password = 'Plofy2012';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username)
    ..recipients.add('antonioardura01@gmail.com')
    ..subject = subject
    ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } catch (e) {
    print('Error sending email: $e');
  }
}

class QuestionnaireScreen extends StatefulWidget {
  final BbddBox lastEmotion;

  const QuestionnaireScreen({required this.lastEmotion});
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  double _playlistRating = 3.0;
  double _emotionRating = 3.0;
  double _effectiveRating = 3.0;
  double _recommendationRating = 3.0;
  double _suitabilityRating = 3.0;
  String _comment = '';
  final emotionsBox = Hive.box<BbddBox>('main');
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final emotion = emotionsBox.get('${widget.lastEmotion.date}');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Questionnaire'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey[800],
          toolbarHeight: 45,
          centerTitle: true,
          actions: [
            IconButton(
              highlightColor: Colors.transparent,
              splashRadius: 1.0,
              hoverColor: Colors.transparent,
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evaluate the playlist recommendation:',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                Column(children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 5.0, // Altura de la barra deslizable
                      thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius:
                              6.0), // Forma del botón deslizable
                      overlayShape: RoundSliderOverlayShape(
                          overlayRadius:
                              20.0), // Forma del overlay de la barra deslizable
                      activeTrackColor: Color.fromARGB(253, 255, 232,
                          177), // Color de la barra deslizable activa
                      inactiveTrackColor: Colors
                          .grey[300], // Color de la barra deslizable inactiva
                      thumbColor: Color.fromARGB(
                          253, 255, 232, 177), // Color del botón deslizable
                    ),
                    child: Slider(
                      value: _playlistRating,
                      min: 1,
                      max: 5,
                      divisions: 16,
                      activeColor: Color.fromARGB(253, 255, 232, 177),
                      label: '$_playlistRating',
                      onChanged: (value) {
                        setState(() {
                          _playlistRating = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Rating: $_playlistRating',
                    style: TextStyle(fontSize: 12),
                  ),
                ]),
                SizedBox(height: 16),
                Text(
                  'Evaluate how helpful it was with your goal emotion:',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                Column(children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 5.0, // Altura de la barra deslizable
                      thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius:
                              6.0), // Forma del botón deslizable
                      overlayShape: RoundSliderOverlayShape(
                          overlayRadius:
                              20.0), // Forma del overlay de la barra deslizable
                      activeTrackColor: Color.fromARGB(253, 255, 232,
                          177), // Color de la barra deslizable activa
                      inactiveTrackColor: Colors
                          .grey[300], // Color de la barra deslizable inactiva
                      thumbColor: Color.fromARGB(
                          253, 255, 232, 177), // Color del botón deslizable
                    ),
                    child: Slider(
                      value: _emotionRating,
                      min: 1,
                      max: 5,
                      divisions: 16,
                      activeColor: Color.fromARGB(253, 255, 232, 177),
                      label: '$_emotionRating',
                      onChanged: (value) {
                        setState(() {
                          _emotionRating = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Rating: $_emotionRating',
                    style: TextStyle(fontSize: 12),
                  ),
                ]),
                SizedBox(height: 16),
                SizedBox(height: 16),
                Text(
                  'Do you consider the playlist effective in influencing your emotional state and achieving the desired emotion?',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5.0,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.0,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 20.0,
                        ),
                        activeTrackColor: Color.fromARGB(253, 255, 232, 177),
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Color.fromARGB(253, 255, 232, 177),
                      ),
                      child: Slider(
                        value: _effectiveRating,
                        min: 1,
                        max: 5,
                        divisions: 16,
                        activeColor: Color.fromARGB(253, 255, 232, 177),
                        onChanged: (value) {
                          setState(() {
                            _effectiveRating = value;
                          });
                        },
                        label: '$_effectiveRating',
                      ),
                    ),
                    Text(
                      'Rating: $_effectiveRating',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Were the songs in the playlist suitable for the journey towards the desired emotion?',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5.0,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.0,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 20.0,
                        ),
                        activeTrackColor: Color.fromARGB(253, 255, 232, 177),
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Color.fromARGB(253, 255, 232, 177),
                      ),
                      child: Slider(
                        value: _suitabilityRating,
                        min: 1,
                        max: 5,
                        divisions: 16,
                        activeColor: Color.fromARGB(253, 255, 232, 177),
                        onChanged: (value) {
                          setState(() {
                            _suitabilityRating = value;
                          });
                        },
                        label: '$_suitabilityRating',
                      ),
                    ),
                    Text(
                      'Rating: $_suitabilityRating',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Would you recommend this playlist to others seeking to experience the same emotion?',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5.0,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.0,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 20.0,
                        ),
                        activeTrackColor: Color.fromARGB(253, 255, 232, 177),
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Color.fromARGB(253, 255, 232, 177),
                      ),
                      child: Slider(
                        value: _recommendationRating,
                        min: 1,
                        max: 5,
                        divisions: 16,
                        activeColor: Color.fromARGB(253, 255, 232, 177),
                        onChanged: (value) {
                          setState(() {
                            _recommendationRating = value;
                          });
                        },
                        label: '$_recommendationRating',
                      ),
                    ),
                    Text(
                      'Rating: $_recommendationRating',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  'Comments:',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _comment = value;
                    });
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    editEmotion(
                        emotion!,
                        widget.lastEmotion.date,
                        widget.lastEmotion.emotion,
                        widget.lastEmotion.area,
                        widget.lastEmotion.dairyDescription,
                        widget.lastEmotion.dairyText,
                        _emotionRating,
                        _suitabilityRating,
                        _playlistRating,
                        _effectiveRating);
                    sendEmail('datosRecogidos-appPrueba',
                        ' Evaluate the playlist recommendation:${_playlistRating} , Evaluate how helpful it was with your goal emotion: ${_emotionRating} , Do you consider the playlist effective in influencing your emotional state and achieving the desired emotion?: ${_effectiveRating} , Were the songs in the playlist suitable for the journey towards the desired emotion?: ${_suitabilityRating} || Would you recommend this playlist to others seeking to experience the same emotion?: ${_recommendationRating}; COMMENTS: $_comment');
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(198, 20, 163, 185),
                  ),
                )),
              ],
            )),
          )),
          Container(
            height: 80,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(size.width, 80),
                  painter: navBar(),
                ),
                Center(
                  heightFactor: 1,
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Hero(
                        tag: 'selectEmotion',
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  reverseTransitionDuration:
                                      const Duration(seconds: 1),
                                  pageBuilder: (context, animation, _) {
                                    return FadeTransition(
                                        opacity: animation,
                                        child: EmotionScreen());
                                  }),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Color.fromARGB(255, 20, 163, 185),
                          ),
                          child: Icon(Icons.emoji_emotions),
                        )),
                  ),
                ),
                Container(
                  width: size.width,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        highlightColor: Colors.transparent,
                        splashRadius: 1.0,
                        hoverColor: Colors.transparent,
                        icon: Icon(Icons.home, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SongListPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(-1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      IconButton(
                        highlightColor: Colors.transparent,
                        splashRadius: 1.0,
                        hoverColor: Colors.transparent,
                        icon: Icon(Icons.calendar_month, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      CalendarSummary(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(-1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Container(
                        width: size.width * 0.20,
                      ),
                      IconButton(
                        highlightColor: Colors.transparent,
                        splashRadius: 1.0,
                        hoverColor: Colors.transparent,
                        icon: Icon(Icons.bookmark, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      PlaylistPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(-1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      IconButton(
                        highlightColor: Colors.transparent,
                        splashRadius: 1.0,
                        hoverColor: Colors.transparent,
                        icon: Icon(
                          Icons.rate_review,
                          color: Color.fromARGB(225, 65, 225, 250),
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}

void editEmotion(
  BbddBox emotion,
  DateTime date,
  String emocion,
  String area,
  String description,
  String text,
  double emotionRating,
  double suitabilityRating,
  double playlistRating,
  double effectiveRating,
) {
  // Modificar las propiedades de la emoción
  emotion.date = DateTime.now();
  emotion.emotion = emocion;
  emotion.area = area;
  emotion.dairyDescription = description;
  emotion.dairyText = text;
  emotion.emotionRating = emotionRating;
  emotion.suitabilityRating = suitabilityRating;
  emotion.playlistRating = playlistRating;
  emotion.effectiveRating = effectiveRating;

  // Guardar los cambios en la caja Hive
  emotion.save();
}
