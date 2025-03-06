import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg_v1/controllers/WeeklyFunctions.dart';
import 'package:tfg_v1/controllers/Logout.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/models/PlaylistAndSong.dart';
import 'package:tfg_v1/models/navBar.dart';
import 'package:tfg_v1/repository/repository.dart';
import 'package:tfg_v1/views/CalendarSummaryScreen.dart';
import 'package:tfg_v1/views/EmotionScreen.dart';
import 'package:tfg_v1/views/HomeScreen.dart';
import 'package:tfg_v1/views/PlaylistDetails.dart';
import 'package:tfg_v1/views/QuestionnaireScreen.dart';
import 'package:tfg_v1/views/SearchScreen.dart';

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Playlist> playlists = [];
  final _apiProvider = SpotifyApiProviderList();

  @override
  void initState() {
    super.initState();
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    try {
      List<Playlist> fetchedPlaylists = await _apiProvider.getSavedPlaylists();
      setState(() {
        playlists = fetchedPlaylists;
      });
    } catch (e) {
      print('Error loading playlists: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('My Playlists'),
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
            child: ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    navigateToPlaylistDetails(playlists[index]);
                  },
                  leading: AspectRatio(
                    aspectRatio:
                        1.0, // Establece el aspect ratio como 1:1 para un cuadrado perfecto
                    child: Image.network(
                      playlists[index].imageUrl,
                      fit: BoxFit
                          .cover, // Ajusta la imagen para cubrir todo el cuadro
                    ),
                  ),
                  title: Text(playlists[index].name),
                );
              },
            ),
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
                        icon: Icon(
                          Icons.bookmark,
                          color: Color.fromARGB(225, 65, 225, 250),
                          size: 30,
                        ),
                        onPressed: () {},
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
                                            lastEmotion: lastEmotion),
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
        ]));
  }

  void navigateToPlaylistDetails(Playlist playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlaylistDetailsPage(playlist: playlist)),
    );
  }
}
