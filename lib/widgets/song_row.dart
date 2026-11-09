import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/music_provider.dart';

class SongRow extends StatelessWidget {
  final Song song;
  final int index;
  final VoidCallback? onRemove;

  const SongRow({
    super.key,
    required this.song,
    required this.index,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final isCurrent = provider.currentSong?.id == song.id;
    final isPlaying = isCurrent && provider.isPlaying;
    final isLiked = provider.likedSongIds.contains(song.id);
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return InkWell(
      onTap: () {
        if (isCurrent) {
          provider.togglePlay();
        } else {
          provider.playSong(song);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Track Index or Playing Indicator
            SizedBox(
              width: 24,
              child: isPlaying
                  ? const Icon(Icons.equalizer, color: Color(0xFF1DB954), size: 18)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrent ? const Color(0xFF1DB954) : Colors.white54,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
            ),
            const SizedBox(width: 8),

            // Artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                song.coverUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 40, height: 40, color: Colors.white12),
              ),
            ),
            const SizedBox(width: 12),

            // Title & Artist
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isCurrent ? const Color(0xFF1DB954) : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Album (hidden on mobile)
            if (isDesktop)
              Expanded(
                flex: 3,
                child: Text(
                  song.album,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Actions & Duration
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? const Color(0xFF1DB954) : Colors.white38,
                    size: 18,
                  ),
                  onPressed: () => provider.toggleLike(song.id),
                ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    onPressed: onRemove,
                  ),
                const SizedBox(width: 4),
                Text(
                  song.formattedDuration,
                  style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'monospace'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
