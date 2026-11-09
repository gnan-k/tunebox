import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../widgets/song_row.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Create Playlist button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Library',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB954),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () => Navigator.pushNamed(context, '/create-playlist'),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Create Playlist', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tabs: Playlists & Liked Songs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: const Color(0xFF1DB954),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Playlists (${provider.playlists.length})'),
              Tab(text: 'Liked Songs (${provider.likedSongIds.length})'),
            ],
          ),

          const SizedBox(height: 20),

          // Tab Content Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Playlists Tab
                GridView.builder(
                  itemCount: provider.playlists.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 4 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final pl = provider.playlists[index];
                    return GestureDetector(
                      onTap: () {
                        provider.setActivePlaylist(pl);
                        Navigator.pushNamed(context, '/playlist-details');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF181818),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  pl.coverUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: Colors.white12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              pl.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${pl.trackCount} tracks · ${pl.isCustom ? "By You" : "TuneBox"}',
                              style: const TextStyle(color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // 2. Liked Songs Tab
                provider.likedSongs.isNotEmpty
                    ? ListView.builder(
                        itemCount: provider.likedSongs.length,
                        itemBuilder: (context, index) {
                          return SongRow(song: provider.likedSongs[index], index: index);
                        },
                      )
                    : const Center(
                        child: Text(
                          'No liked songs yet. Tap the heart icon on any song!',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
