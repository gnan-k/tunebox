import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/music_provider.dart';
import 'widgets/responsive_scaffold.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/library_screen.dart';
import 'screens/playlist_detail_screen.dart';
import 'screens/player_screen.dart';
import 'screens/create_playlist_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicProvider()),
      ],
      child: const TuneBoxApp(),
    ),
  );
}

class TuneBoxApp extends StatelessWidget {
  const TuneBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuneBox — Music Player App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1DB954),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
          surface: Color(0xFF181818),
          background: Color(0xFF121212),
          secondary: Color(0xFF1ED760),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF181818),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white10, width: 1),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ResponsiveScaffold(child: HomeScreen()),
        '/search': (context) => const ResponsiveScaffold(child: SearchScreen()),
        '/library': (context) => const ResponsiveScaffold(child: LibraryScreen()),
        '/playlist-details': (context) =>
            const ResponsiveScaffold(child: PlaylistDetailScreen()),
        '/player': (context) => const PlayerScreen(),
        '/create-playlist': (context) => const CreatePlaylistScreen(),
        '/profile': (context) => const ResponsiveScaffold(child: ProfileScreen()),
        '/settings': (context) => const ResponsiveScaffold(child: SettingsScreen()),
      },
    );
  }
}
