import 'dart:async';
import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:tfg_v1/models/AuthorizationModel.dart';
import 'package:tfg_v1/models/PlaylistAndSong.dart';

//import 'package:alarmfy/src/models/list_playlist_model.dart';
//import 'package:alarmfy/src/models/tracks_playlist_model.dart';

class RepositoryAuthorization {
  final authorizationCodeApiProvider = AuthorizationApiProvider();
  final authorizationTokenApiProvider = AuthorizationTokenApiProvider();
  Future<String?> fetchAuthorizationCode() =>
      authorizationCodeApiProvider.fetchCode();
  Future<AuthorizationModel> fetchAuthorizationToken(String code) =>
      authorizationTokenApiProvider.fetchToken(code);
}

class AuthorizationApiProvider {
  Client client = Client();

  static String url = "https://accounts.spotify.com/authorize";
  static String client_id = "aa2026414d974acc92c406408ef5abb0";
  static String response_type = "code";
  static String redirect_uri = "tfgv1:/";
  static String scope =
      "playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private user-top-read user-read-recently-played user-library-read ";

  String urlDireccion = "$url" +
      "?client_id=$client_id" +
      "&response_type=$response_type" +
      "&redirect_uri=$redirect_uri" +
      "&scope=$scope";

  Future<String?> fetchCode() async {
    final response = await FlutterWebAuth.authenticate(
        url: urlDireccion, callbackUrlScheme: "tfgv1");
    final error = Uri.parse(response).queryParameters['error'];
    if (error == null) {
      final code = Uri.parse(response).queryParameters['code'];
      return code;
    } else {
      print("Error al autenticar");
      return error;
    }
  }
}

class AuthorizationTokenApiProvider {
  Client client = Client();
  static String client_id = "aa2026414d974acc92c406408ef5abb0";
  static String client_secret = "b9571ebe9dc34be78e840c5848e96210";

  static String AuthorizationStr = "$client_id:$client_secret";
  static var bytes = utf8.encode(AuthorizationStr);
  static var base64Str = base64.encode(bytes);

  String Authorization = 'Basic ' + base64Str;

  var urlToToken = 'https://accounts.spotify.com/api/token';

  Future<AuthorizationModel> fetchToken(String code) async {
    var response = await client.post(Uri.parse(urlToToken), body: {
      'grant_type': "authorization_code",
      'code': code,
      'redirect_uri': 'tfgv1:/'
    }, headers: {
      'Authorization': Authorization
    });

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return AuthorizationModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<String> getToken() async {
    final authApiProvider = AuthorizationApiProvider();
    final code = await authApiProvider.fetchCode();
    final authProvider = AuthorizationTokenApiProvider();
    final token = await authProvider.fetchToken(code!);
    return token.accessToken;
  }
}

class SpotifyApiProvider {
  Client client = Client();
  static String baseUrl = "https://api.spotify.com/v1";
  static const String _baseUrl = 'https://api.spotify.com';

  Future<void> logout() async {
    // Eliminar el token de acceso almacenado en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    prefs.remove('token_type');
    prefs.remove('refresh_token');
    prefs.remove('logged');

    // Realizar la solicitud HTTP para revocar el token de acceso en Spotify
    String accessToken = prefs.getString('access_token') ?? '';
    String tokenType = prefs.getString('token_type') ?? '';
    String revokeUrl = '$_baseUrl/v1/tokens/revoke';
    await http.post(
      Uri.parse(revokeUrl),
      headers: {
        'Authorization': '$tokenType $accessToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
  }

  Future<List<String>> search(String query) async {
    final token = await AuthorizationTokenApiProvider()
        .getToken(); // Obtener el token de autorización
    final response = await client.get(
      Uri.parse('$baseUrl/search?q=$query&type=track'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final items = json['tracks']['items'] as List<dynamic>;
      final titles = items.map((e) => e['name'] as String).toList();
      return titles;
    } else {
      throw Exception('Failed to load search results');
    }
  }
}

class SpotifyApiProviderList {
  Client client = Client();
  static String baseUrl = "https://api.spotify.com/v1";

  Future<List<String>> getUserPlaylists() async {
    final token = await AuthorizationTokenApiProvider()
        .getToken(); // Obtener el token de autorización
    final response = await client.get(
      Uri.parse('$baseUrl/me/playlists'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final items = json['items'] as List<dynamic>;
      final titles = items.map((e) => e['name'] as String).toList();
      return titles;
    } else {
      throw Exception('Failed to load user playlists');
    }
  }

  Future<List<Playlist>> search(String query) async {
    final token = await AuthorizationTokenApiProvider().getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/search?q=$query&type=playlist'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final items = json['playlists']['items'] as List<dynamic>;
      final playlists = items.map((item) {
        final name = item['name'] as String;
        final imageUrl = item['images'][0]['url']
            as String; // Usa la primera imagen como portada
        final playlistId = item['id'] as String;
        return Playlist(name: name, imageUrl: imageUrl, playlistId: playlistId);
      }).toList();
      return playlists;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<List<Playlist>> getSavedPlaylists() async {
    final token = await AuthorizationTokenApiProvider().getToken();

    String playlistsUrl = 'https://api.spotify.com/v1/me/playlists';
    var response = await http.get(
      Uri.parse(playlistsUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<dynamic> playlistItems = json['items'];
      List<Playlist> playlists = [];

      for (var item in playlistItems) {
        var name = item['name'];
        var imageUrl =
            item['images'][0]['url']; // Usa la primera imagen como portada
        var playlistId = item['id'];
        var playlist =
            Playlist(name: name, imageUrl: imageUrl, playlistId: playlistId);
        playlists.add(playlist);
      }

      return playlists;
    } else {
      throw Exception('Error al obtener las playlists guardadas');
    }
  }

  Future<List<Song>> getPlaylistSongs(Playlist playlist) async {
    final token = await AuthorizationTokenApiProvider().getToken();

    String playlistSongsUrl =
        'https://api.spotify.com/v1/playlists/${playlist.playlistId}/tracks';
    var response = await http.get(
      Uri.parse(playlistSongsUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<dynamic> songItems = json['items'];
      List<Song> songs = [];

      for (var item in songItems) {
        var name = item['track']['name'];
        var imageUrl = item['track']['album']['images'][0]['url'];
        var trackUri = item['track']['uri'];
        var song = Song(name: name, imageUrl: imageUrl, trackUri: trackUri);
        songs.add(song);
      }

      return songs;
    } else {
      throw Exception('Error al obtener las canciones de la playlist');
    }
  }

  Future<List<Song>> getSpotifyRecommendations(
      Map<String, List<double>> parameters) async {
    final token = await AuthorizationTokenApiProvider().getToken();
    Set<Song> songs = {}; // Use a Set instead of a List

    // Obtener las 5 mejores canciones del usuario en el período de tiempo especificado
    String topTracksUrl =
        'https://api.spotify.com/v1/me/top/tracks?time_range=medium_term&limit=4';
    var topTracksResponse = await http.get(
      Uri.parse(topTracksUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(topTracksResponse.statusCode);

    if (topTracksResponse.statusCode == 200) {
      var topTracksJson = json.decode(topTracksResponse.body);
      List<String> topTrackIds = [];
      for (var item in topTracksJson['items']) {
        topTrackIds.add(item['id']);
      }

      int numTracksToAdd = 10;
      Map<String, int> repeatedSongs =
          {}; // Track the number of repetitions for each song

      while (songs.length < numTracksToAdd) {
        String query =
            'https://api.spotify.com/v1/recommendations?limit=1&seed_tracks=${topTrackIds.join(',')}';
        for (var parameter in parameters.keys) {
          List<double>? values = parameters[parameter];
          double value = values![songs.length % values.length];
          query += '&$parameter=$value';
        }
        print(query);
        var recommendationsResponse = await http.get(
          Uri.parse(query),
          headers: {'Authorization': 'Bearer $token'},
        );
        print(recommendationsResponse.statusCode);
        if (recommendationsResponse.statusCode == 200) {
          var recommendationsJson = json.decode(recommendationsResponse.body);
          var item = recommendationsJson['tracks'][0];

          var song = Song(
            name: item['name'],
            imageUrl: item['album']['images'][0]['url'],
            trackUri: item['uri'],
          );
          print(song.name);
          if (!songs.contains(song)) {
            songs.add(song); // Add the song to the Set (avoid duplicates)
          } else {
            repeatedSongs[song.name] = (repeatedSongs[song.name] ?? 0) + 1;
            if (repeatedSongs[song.name]! > 5) {
              // Decrease parameter values by 0.03
              for (var parameter in parameters.keys) {
                List<double>? values = parameters[parameter];
                for (var i = 0; i < values!.length; i++) {
                  values[i] = (values[i] - 0.0003).clamp(0.0, 1.0);
                }
              }
            }
          }
        } else if (recommendationsResponse.statusCode == 504) {
          // Retry the query
          continue;
        } else {
          throw Exception('Error al obtener recomendacion de Spotify');
        }
      }

      return songs.toList(); // Convert the Set to a List before returning
    } else {
      throw Exception('Error al obtener las 5 mejores canciones del usuario');
    }
  }

  Future<void> createPlaylist(List<Song> songs, String playlistName) async {
    final token = await AuthorizationTokenApiProvider().getToken();

    // Crear la playlist
    var createPlaylistResponse = await http.post(
      Uri.parse('https://api.spotify.com/v1/me/playlists'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': playlistName}),
    );
    if (createPlaylistResponse.statusCode == 201) {
      var createPlaylistJson = json.decode(createPlaylistResponse.body);
      var playlistId = createPlaylistJson['id'];

      // Agregar las canciones a la playlist
      var addTracksResponse = await http.post(
        Uri.parse('https://api.spotify.com/v1/playlists/$playlistId/tracks'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'uris': songs.map((song) => song.trackUri).toList()}),
      );
      print(addTracksResponse.statusCode);
      if (addTracksResponse.statusCode == 201) {
        print('Playlist creada correctamente');
      } else {
        throw Exception('Error al agregar canciones a la playlist');
      }
    } else {
      throw Exception('Error al crear la playlist');
    }
  }
}
