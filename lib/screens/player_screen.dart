import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final song = provider.currentSong;

    if (song == null) {
      return const Scaffold(body: Center(child: Text('No song playing')));
    }

    final isLiked = provider.likedSongIds.contains(song.id);
    final posSec = provider.position.inSeconds.toDouble();
    final durSec = provider.duration.inSeconds > 0 ? provider.duration.inSeconds.toDouble() : song.duration.toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'PLAYING FROM ALBUM',
              style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: Color(0xFF1DB954), fontWeight: FontWeight.bold),
            ),
            Text(
              song.album,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Big Album Artwork
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    song.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.white12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Title, Artist, & Like Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song.artist,
                          style: const TextStyle(fontSize: 14, color: Colors.white60),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? const Color(0xFF1DB954) : Colors.white60,
                      size: 28,
                    ),
                    onPressed: () => provider.toggleLike(song.id),
                  ),
                ],
              ),

              // Progress Bar Slider & Timestamps
              Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF1DB954),
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      value: posSec.clamp(0.0, durSec),
                      min: 0.0,
                      max: durSec > 0 ? durSec : 1.0,
                      onChanged: (val) {
                        provider.seekTo(Duration(seconds: val.toInt()));
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(provider.position),
                        style: const TextStyle(fontSize: 12, color: Colors.white54, fontFamily: 'monospace'),
                      ),
                      Text(
                        _formatDuration(provider.duration.inSeconds > 0 ? provider.duration : Duration(seconds: song.duration)),
                        style: const TextStyle(fontSize: 12, color: Colors.white54, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ],
              ),

              // Controls: Shuffle, Previous, Play/Pause, Next, Repeat
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shuffle,
                      color: provider.isShuffle ? const Color(0xFF1DB954) : Colors.white54,
                      size: 24,
                    ),
                    onPressed: provider.toggleShuffle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 36, color: Colors.white),
                    onPressed: provider.previousSong,
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1DB954),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        provider.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 38,
                      ),
                      onPressed: provider.togglePlay,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 36, color: Colors.white),
                    onPressed: provider.nextSong,
                  ),
                  IconButton(
                    icon: Icon(
                      provider.repeatMode == 'one' ? Icons.repeat_one : Icons.repeat,
                      color: provider.repeatMode != 'off' ? const Color(0xFF1DB954) : Colors.white54,
                      size: 24,
                    ),
                    onPressed: provider.toggleRepeat,
                  ),
                ],
              ),

              // Synchronized Lyrics Preview
              if (song.lyrics.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LYRICS',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        song.lyrics.first,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
