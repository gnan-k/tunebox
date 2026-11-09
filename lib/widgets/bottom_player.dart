import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final song = provider.currentSong;
    if (song == null) return const SizedBox.shrink();

    final isLiked = provider.likedSongIds.contains(song.id);
    final posSec = provider.position.inSeconds.toDouble();
    final durSec = provider.duration.inSeconds > 0 ? provider.duration.inSeconds.toDouble() : song.duration.toDouble();

    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return GestureDetector(
      onTap: () {
        if (!isDesktop) {
          Navigator.pushNamed(context, '/player');
        }
      },
      child: Container(
        height: isDesktop ? 90 : 70,
        decoration: const BoxDecoration(
          color: Color(0xFF181818),
          border: Border(top: BorderSide(color: Colors.white10, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                // Left: Song Artwork & Details
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    song.coverUrl,
                    width: isDesktop ? 56 : 46,
                    height: isDesktop ? 56 : 46,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: Colors.white12,
                      child: const Icon(Icons.music_note, color: Colors.white54),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: isDesktop ? 2 : 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        song.artist,
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Like Button
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? const Color(0xFF1DB954) : Colors.white54,
                    size: 20,
                  ),
                  onPressed: () => provider.toggleLike(song.id),
                ),

                // Center: Playback Controls (On Desktop)
                if (isDesktop) ...[
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.shuffle,
                                color: provider.isShuffle ? const Color(0xFF1DB954) : Colors.white54,
                                size: 18,
                              ),
                              onPressed: provider.toggleShuffle,
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_previous, size: 22, color: Colors.white70),
                              onPressed: provider.previousSong,
                            ),
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  provider.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.black,
                                  size: 22,
                                ),
                                onPressed: provider.togglePlay,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next, size: 22, color: Colors.white70),
                              onPressed: provider.nextSong,
                            ),
                            IconButton(
                              icon: Icon(
                                provider.repeatMode == 'one' ? Icons.repeat_one : Icons.repeat,
                                color: provider.repeatMode != 'off' ? const Color(0xFF1DB954) : Colors.white54,
                                size: 18,
                              ),
                              onPressed: provider.toggleRepeat,
                            ),
                          ],
                        ),
                        // Desktop Progress Bar with Timers
                        Row(
                          children: [
                            Text(
                              _formatDuration(provider.position),
                              style: const TextStyle(fontSize: 10, color: Colors.white54, fontFamily: 'monospace'),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                  activeTrackColor: const Color(0xFF1DB954),
                                  inactiveTrackColor: Colors.white24,
                                  thumbColor: Colors.white,
                                  trackHeight: 2.5,
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
                            ),
                            Text(
                              _formatDuration(provider.duration.inSeconds > 0 ? provider.duration : Duration(seconds: song.duration)),
                              style: const TextStyle(fontSize: 10, color: Colors.white54, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right: Volume & Fullscreen Button
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.fullscreen, color: Colors.white70, size: 22),
                          onPressed: () => Navigator.pushNamed(context, '/player'),
                        ),
                        const Icon(Icons.volume_up, size: 18, color: Colors.white54),
                        SizedBox(
                          width: 80,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                              activeTrackColor: const Color(0xFF1DB954),
                              inactiveTrackColor: Colors.white24,
                              thumbColor: Colors.white,
                              trackHeight: 2,
                            ),
                            child: Slider(
                              value: provider.volume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (v) => provider.setVolume(v),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Mobile compact play button
                  IconButton(
                    icon: Icon(
                      provider.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: provider.togglePlay,
                  ),
                ],
              ],
            ),
          ],
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
