import 'package:flutter/material.dart';
import 'package:tfg_v1/models/PlaylistAndSong.dart';
import 'package:tfg_v1/repository/repository.dart';
import 'package:tfg_v1/views/MyPlaylists.dart';

class PlaylistDetailsPage extends StatelessWidget {
  final Playlist playlist;

  PlaylistDetailsPage({required this.playlist});
  final _apiProvider = SpotifyApiProviderList();
  @override
  Widget build(BuildContext context) {
    final _apiProvider = SpotifyApiProviderList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 3,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        title: Text(playlist.name),
        backgroundColor: Colors.blueGrey[800],
        toolbarHeight: 45,
      ),
      body: FutureBuilder<List<Song>>(
        future: _apiProvider.getPlaylistSongs(playlist),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading playlist songs'),
            );
          } else if (snapshot.hasData) {
            List<Song> songs = snapshot.data!;
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: AspectRatio(
                    aspectRatio:
                        1.0, // Establece el aspect ratio como 1:1 para un cuadrado perfecto
                    child: Image.network(
                      songs[index].imageUrl,
                      fit: BoxFit
                          .cover, // Ajusta la imagen para cubrir todo el cuadro
                    ),
                  ),
                  title: Text(songs[index].name),
                  onTap: () {
                    // Realizar la acción que desees al hacer clic en una canción
                  },
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
