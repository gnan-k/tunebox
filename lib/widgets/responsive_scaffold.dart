import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import 'bottom_player.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;

  const ResponsiveScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final isTablet = width >= 640 && !isDesktop;
    final provider = context.watch<MusicProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          // Desktop & Tablet Navigation Rail
          if (isDesktop || isTablet)
            NavigationRail(
              backgroundColor: Colors.black,
              selectedIndex: _getSelectedIndex(context),
              onDestinationSelected: (index) => _onDestinationSelected(context, index),
              extended: isDesktop,
              minExtendedWidth: 230,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1DB954), Color(0xFF1ED760)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.music_note, color: Colors.black, size: 22),
                    ),
                    if (isDesktop) ...[
                      const SizedBox(width: 12),
                      const Text(
                        'TuneBox',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ],
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: Color(0xFF1DB954)),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search, color: Color(0xFF1DB954)),
                  label: Text('Search'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.library_music_outlined),
                  selectedIcon: Icon(Icons.library_music, color: Color(0xFF1DB954)),
                  label: Text('Your Library'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: Color(0xFF1DB954)),
                  label: Text('Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings, color: Color(0xFF1DB954)),
                  label: Text('Settings'),
                ),
              ],
            ),

          // Main Viewport
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF121212),
                    border: Border(bottom: BorderSide(color: Colors.white10)),
                  ),
                  child: Row(
                    children: [
                      if (Navigator.canPop(context))
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      const Spacer(),
                      // Profile Avatar Pill
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF242424),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(provider.userProfile.avatarUrl),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                provider.userProfile.name,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content View
                Expanded(child: child),

                // Persistent Bottom Player
                const BottomPlayer(),
              ],
            ),
          ),
        ],
      ),

      // Mobile Bottom Navigation Bar (< 640px)
      bottomNavigationBar: (!isDesktop && !isTablet)
          ? BottomNavigationBar(
              backgroundColor: const Color(0xFF181818),
              selectedItemColor: const Color(0xFF1DB954),
              unselectedItemColor: Colors.white54,
              currentIndex: _getSelectedIndex(context),
              type: BottomNavigationBarType.fixed,
              onTap: (index) => _onDestinationSelected(context, index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            )
          : null,
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    switch (route) {
      case '/search':
        return 1;
      case '/library':
        return 2;
      case '/profile':
        return 3;
      case '/settings':
        return 4;
      default:
        return 0;
    }
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final routes = ['/', '/search', '/library', '/profile', '/settings'];
    if (index >= 0 && index < routes.length) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }
}
