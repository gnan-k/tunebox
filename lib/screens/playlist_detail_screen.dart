import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../widgets/song_row.dart';

class PlaylistDetailScreen extends StatelessWidget {
  const PlaylistDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final playlist = provider.activePlaylist ?? (provider.playlists.isNotEmpty ? provider.playlists.first : null);

    if (playlist == null) {
      return const Scaffold(
        body: Center(child: Text('No playlist selected')),
      );
    }

    final songs = playlist.songIds
        .map((id) => provider.songs.where((s) => s.id == id).firstOrNull)
        .whereType<dynamic>()
        .toList();

    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Giant Gradient Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(int.parse(playlist.colorHex)).withOpacity(0.8),
                  const Color(0xFF121212),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    playlist.coverUrl,
                    width: isDesktop ? 180 : 120,
                    height: isDesktop ? 180 : 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 120, height: 120, color: Colors.white12),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlist.isCustom ? 'CUSTOM PLAYLIST' : 'FEATURED PLAYLIST',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF1DB954)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        playlist.name,
                        style: TextStyle(
                          fontSize: isDesktop ? 36 : 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        playlist.description,
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${playlist.trackCount} songs · TuneBox',
                        style: const TextStyle(fontSize: 12, color: Colors.white54, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Controls & Action Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 16),
            child: Row(
              children: [
                // Big Green Play Button
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1DB954),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.black, size: 30),
                    onPressed: () {
                      if (songs.isNotEmpty) {
                        provider.playSong(songs.first, playlist);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.shuffle, color: Colors.white70, size: 26),
                  onPressed: provider.toggleShuffle,
                ),
                const SizedBox(width: 8),
                // Add Song to Playlist Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => _showAddSongDialog(context, provider, playlist.id),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Songs'),
                ),
                const Spacer(),
                if (playlist.isCustom)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      provider.deletePlaylist(playlist.id);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),

          // Tracklist Table
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
            child: songs.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return SongRow(
                        song: song,
                        index: index,
                        onRemove: playlist.isCustom
                            ? () => provider.removeSongFromPlaylist(playlist.id, song.id)
                            : null,
                      );
                    },
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text('Playlist is empty. Click "Add Songs" to populate.', style: TextStyle(color: Colors.white54)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddSongDialog(BuildContext context, MusicProvider provider, String playlistId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF242424),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Song to Playlist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.songs.length,
                  itemBuilder: (context, index) {
                    final song = provider.songs[index];
                    return ListTile(
                      leading: Image.network(song.coverUrl, width: 40, height: 40, fit: BoxFit.cover),
                      title: Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1DB954)),
                        onPressed: () {
                          provider.addSongToPlaylist(playlistId, song.id);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
