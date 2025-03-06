class Playlist {
  final String name;
  final String imageUrl;
  final String playlistId;

  Playlist({
    required this.name,
    required this.imageUrl,
    required this.playlistId,
  });
}

class Song {
  final String name;
  final String imageUrl;
  final String trackUri;

  Song({required this.name, required this.imageUrl, required this.trackUri});

  @override
  int get hashCode => trackUri.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          trackUri == other.trackUri;
}

List<Song> songsRecommendation = [];
