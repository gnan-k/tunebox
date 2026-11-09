import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../widgets/song_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Synthwave', 'Lo-Fi', 'Acoustic', 'Techno', 'Jazz'];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final songs = _selectedCategory == 'All'
        ? provider.songs
        : provider.songs.where((s) => s.genre.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final isTablet = width >= 640 && !isDesktop;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Quick Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Curated soundscapes and personalized selections for you',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB954),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  if (provider.songs.isNotEmpty) {
                    provider.playSong(provider.songs.first);
                  }
                },
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text('Play Daily Mix', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    backgroundColor: const Color(0xFF242424),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 28),

          // 6-Tile Spotify Hero Grid
          GridView.count(
            crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: isDesktop ? 3.5 : 3.2,
            children: [
              // Liked Songs Hero Tile
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/library'),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF242424),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.indigo, Colors.purple]),
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                        ),
                        child: const Center(child: Icon(Icons.favorite, color: Colors.white, size: 28)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Liked Songs (${provider.likedSongIds.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Playlists Hero Tiles
              ...provider.playlists.take(5).map((pl) {
                return GestureDetector(
                  onTap: () {
                    provider.setActivePlaylist(pl);
                    Navigator.pushNamed(context, '/playlist-details');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF242424),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                          child: Image.network(
                            pl.coverUrl,
                            width: 64,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 64, color: Colors.white12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            pl.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: Color(0xFF1DB954), size: 32),
                          onPressed: () {
                            if (pl.songIds.isNotEmpty) {
                              final song = provider.songs.firstWhere((s) => s.id == pl.songIds.first);
                              provider.playSong(song, pl);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 36),

          // Featured Playlists Section
          const Text(
            'Featured Playlists',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.playlists.length,
              itemBuilder: (context, index) {
                final pl = provider.playlists[index];
                return GestureDetector(
                  onTap: () {
                    provider.setActivePlaylist(pl);
                    Navigator.pushNamed(context, '/playlist-details');
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            pl.coverUrl,
                            width: 126,
                            height: 126,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 126, height: 126, color: Colors.white12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pl.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${pl.trackCount} tracks',
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 36),

          // Trending Songs Grid
          Text(
            _selectedCategory == 'All' ? 'Trending Songs' : '$_selectedCategory Tracks',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: songs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 5 : (isTablet ? 3 : 2),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              return SongCard(song: songs[index]);
            },
          ),
        ],
      ),
    );
  }
}
