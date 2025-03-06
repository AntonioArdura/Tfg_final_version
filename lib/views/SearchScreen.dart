import 'package:flutter/material.dart';
import 'package:tfg_v1/models/PlaylistAndSong.dart';
import 'package:tfg_v1/models/navBar.dart';
import 'package:tfg_v1/repository/repository.dart';
import 'package:tfg_v1/views/EmotionScreen.dart';
import 'package:tfg_v1/views/CalendarSummaryScreen.dart';
import 'package:tfg_v1/views/HomeScreen.dart';
import 'package:tfg_v1/views/MyPlaylists.dart';
import 'package:tfg_v1/views/WeeklyScreen.dart';

class SearchScreen extends StatefulWidget {
  final List<Playlist> results;
  const SearchScreen({required this.results});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _apiProvider = SpotifyApiProvider();

  List<Playlist> _results = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Playlist for my feel')),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(198, 20, 163, 185),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.results.length,
              itemBuilder: (BuildContext context, int index) {
                final playlist = widget.results[index];
                return ListTile(
                  leading: Image.network(
                    playlist.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(playlist.name),
                  onTap: () {
                    // Aquí puedes agregar la lógica para manejar la selección de una playlist
                  },
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmotionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Color.fromARGB(255, 20, 163, 185),
                      ),
                      child: Icon(Icons.emoji_emotions),
                    ),
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
                            MaterialPageRoute(
                              builder: (context) => SongListPage(),
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
                            MaterialPageRoute(
                              builder: (context) => CalendarSummary(),
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
                              MaterialPageRoute(
                                  builder: (context) => PlaylistPage()));
                        },
                      ),
                      IconButton(
                        highlightColor: Colors.transparent,
                        splashRadius: 1.0,
                        hoverColor: Colors.transparent,
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ProfileScreen()));
                          // emotionToday = getLastEmotionForToday();
                          // final results =
                          //     await _apiProvider.search(emotionToday.emotion);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SearchScreen(
                          //               results: results,
                          //             )));
                        },
                      ),
                    ],
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
