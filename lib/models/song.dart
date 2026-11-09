class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final int duration; // in seconds
  final String coverUrl;
  final String genre;
  final int releaseYear;
  final List<String> lyrics;
  final String audioUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.coverUrl,
    required this.genre,
    required this.releaseYear,
    this.lyrics = const [],
    this.audioUrl = '',
  });

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
