class Playlist {
  final String id;
  String name;
  String description;
  final String coverUrl;
  final List<String> songIds;
  final bool isCustom;
  final DateTime createdAt;
  final String colorHex;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverUrl,
    required this.songIds,
    this.isCustom = false,
    required this.createdAt,
    this.colorHex = '0xFF1DB954',
  });

  int get trackCount => songIds.length;
}
