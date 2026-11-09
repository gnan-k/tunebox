import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../widgets/song_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final user = provider.userProfile;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Hero Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF064E3B).withOpacity(0.8), const Color(0xFF181818)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isDesktop ? 48 : 36,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PREMIUM LISTENER', style: TextStyle(fontSize: 10, color: Color(0xFF1DB954), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      const SizedBox(height: 4),
                      Text(user.name, style: TextStyle(fontSize: isDesktop ? 28 : 20, fontWeight: FontWeight.w900, color: Colors.white)),
                      Text('${user.handle} · ${user.email}', style: const TextStyle(fontSize: 12, color: Colors.white54)),
                      const SizedBox(height: 8),
                      Text(user.bio, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () => _showEditProfileDialog(context, provider),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit Profile', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // 4 Listening Statistics Cards
          const Text('Listening Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: isDesktop ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard('Minutes Listened', user.minutesListened.toString(), Icons.access_time, const Color(0xFF1DB954)),
              _buildStatCard('Songs Streamed', user.songsPlayed.toString(), Icons.music_note, Colors.tealAccent),
              _buildStatCard('Top Genre', user.favoriteGenre, Icons.military_tech, Colors.amberAccent),
              _buildStatCard('Daily Streak', '${user.streakDays} Days', Icons.local_fire_department, Colors.orangeAccent),
            ],
          ),

          const SizedBox(height: 32),

          // Recently Streamed Tracks
          const Text('Recently Streamed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.songs.take(4).length,
            itemBuilder: (context, index) {
              return SongRow(song: provider.songs[index], index: index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold), maxLines: 1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, MusicProvider provider) {
    final nameCtrl = TextEditingController(text: provider.userProfile.name);
    final bioCtrl = TextEditingController(text: provider.userProfile.bio);
    final genreCtrl = TextEditingController(text: provider.userProfile.favoriteGenre);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF242424),
          title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bioCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Bio', labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: genreCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Favorite Genre', labelStyle: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954), foregroundColor: Colors.black),
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  provider.updateProfile(
                    name: nameCtrl.text.trim(),
                    bio: bioCtrl.text.trim(),
                    favoriteGenre: genreCtrl.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
