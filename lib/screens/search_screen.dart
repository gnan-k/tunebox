import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../widgets/song_row.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _browseGenres = [
    {'name': 'Synthwave', 'color': Colors.deepPurple},
    {'name': 'Lo-Fi', 'color': Colors.amber[900]},
    {'name': 'Acoustic', 'color': Colors.teal[900]},
    {'name': 'Techno', 'color': Colors.blueGrey[900]},
    {'name': 'Jazz', 'color': Colors.brown[800]},
    {'name': 'Rock', 'color': Colors.red[900]},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final songs = provider.filteredSongs;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input Bar
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF242424),
              hintText: 'What do you want to listen to? Songs, artists, genres...',
              hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              suffixIcon: provider.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white70),
                      onPressed: () {
                        _searchController.clear();
                        provider.setSearchQuery('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFF1DB954), width: 1.5),
              ),
            ),
            onChanged: (val) {
              provider.setSearchQuery(val);
            },
          ),

          const SizedBox(height: 16),

          // Genre filter pill if selected
          if (provider.selectedGenre != null)
            Row(
              children: [
                Chip(
                  backgroundColor: const Color(0xFF1DB954),
                  label: Text(
                    'Genre: ${provider.selectedGenre}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16, color: Colors.black),
                  onDeleted: () => provider.setSelectedGenre(null),
                ),
              ],
            ),

          const SizedBox(height: 24),

          // Show Browse Genres if no search query
          if (provider.searchQuery.isEmpty && provider.selectedGenre == null) ...[
            const Text(
              'Browse All Genres',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _browseGenres.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.8,
              ),
              itemBuilder: (context, index) {
                final genre = _browseGenres[index];
                return GestureDetector(
                  onTap: () {
                    provider.setSelectedGenre(genre['name']);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: genre['color'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      genre['name'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            // Search Results
            Text(
              'Search Results (${songs.length})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            if (songs.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return SongRow(song: songs[index], index: index);
                },
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'No songs found matching your search.',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
