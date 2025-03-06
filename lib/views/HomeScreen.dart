import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg_v1/controllers/WeeklyFunctions.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/models/PlaylistAndSong.dart';
import 'package:tfg_v1/models/moodVariables.dart';
import 'package:tfg_v1/models/navBar.dart';
import 'package:tfg_v1/repository/repository.dart';
import 'package:tfg_v1/views/CalendarSummaryScreen.dart';
import 'package:tfg_v1/views/EmotionScreen.dart';
import 'package:tfg_v1/views/LoadingRecomendationScreen.dart';
import 'package:tfg_v1/views/MyPlaylists.dart';
import 'package:tfg_v1/controllers/Logout.dart';
import 'package:tfg_v1/views/QuestionnaireScreen.dart';
import 'package:tfg_v1/views/SearchScreen.dart';
import 'package:tfg_v1/views/WeeklyScreen.dart';

class SongListPage extends StatefulWidget {
  @override
  _SongListPageState createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final _apiProvider = SpotifyApiProviderList();
  final emotion = getLastEmotionForToday();
  late BbddBox emotionToday;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Recommended Playlist'),
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
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Column(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final songs = songsRecommendation;
                          TextEditingController playlistNameController =
                              TextEditingController();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Playlist Name'),
                                content: TextField(
                                  controller: playlistNameController,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel',
                                        style: TextStyle(color: Colors.white)),
                                    // style: ElevatedButton.styleFrom(
                                    //   primary: Colors.transparent,
                                    // ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _apiProvider.createPlaylist(
                                        songs,
                                        playlistNameController.text,
                                      );
                                      mostrarMenuDesplegable(context);
                                    },
                                    child: Text('Save',
                                        style: TextStyle(color: Colors.white)),
                                    // style: ElevatedButton.styleFrom(
                                    //   primary: Colors.transparent,
                                    // ),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          print('Error creating playlist: $e');
                        }
                      },
                      child: Text('Save in Spotify'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true; // Activar la pantalla de carga
                        });

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
                        Navigator.pop(context);
                      },
                      child: Text('Reload'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(198, 20, 163, 185),
                      ),
                    ),
                  ]),
            ),
            Expanded(
              // child: FutureBuilder<List<Song>>(
              //   future: _futureSongs,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) { return
              child: ListView.builder(
                itemCount: songsRecommendation.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(songsRecommendation[index].name),
                    leading: Image.network(songsRecommendation[index].imageUrl),
                  );
                },
              ),
              // } else if (snapshot.hasError) {
              //   return Text('Error al obtener recomendaciones');
              // } else {
              //   return CircularProgressIndicator();
              // }
              // },
              // ),
            ),
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
                              backgroundColor:
                                  Color.fromARGB(255, 20, 163, 185),
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
                          icon: Icon(
                            Icons.home,
                            color: Color.fromARGB(225, 65, 225, 250),
                            size: 30,
                          ),
                          onPressed: () {},
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
                                  var begin = Offset(1.0, 0.0);
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
                                  var begin = Offset(1.0, 0.0);
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
                          icon: Icon(Icons.rate_review, color: Colors.white),
                          onPressed: () {
                            BbddBox lastEmotion = getLastEmotionForToday();
                            (lastEmotion.playlistRating == 0.0)
                                ? Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          QuestionnaireScreen(
                                        lastEmotion: lastEmotion,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin = Offset(1.0, 0.0);
                                        var end = Offset.zero;
                                        var curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  )
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                          'Questionnaire Already Filled',
                                        ),
                                        // content: Text('The questionnaire has already been filled.'),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ])
        ]));
  }
}

void mostrarMenuDesplegable(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        // Contenido del menú desplegable
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Text('Please complete the satisfaction questionnaire')),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Go to the questionnaire'),
              onTap: () {
                BbddBox lastEmotion = getLastEmotionForToday();
                (lastEmotion.playlistRating == 0.0)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionnaireScreen(
                                  lastEmotion: lastEmotion,
                                )))
                    : showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text(
                              'Questionnaire Already Filled',
                            ),
                            // content: Text('The questionnaire has already been filled.'),
                            actions: [
                              CupertinoDialogAction(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Close'),
              onTap: () {
                // Acción al seleccionar la opción del menú
                Navigator.pop(context); // Cierra el menú desplegable
              },
            ),
          ],
        ),
      );
    },
  );
}
