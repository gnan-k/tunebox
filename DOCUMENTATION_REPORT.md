# TuneBox — Music Player App: Comprehensive Project Documentation Report

**Course**: Mobile & Web Application Development (Flutter & Dart)  
**Project Title**: TuneBox — Modern Responsive Dark-Mode Music Player Web App  
**Architecture**: Flutter 3.x Web, Provider State Management, audioplayers  
**Theme**: Spotify-Inspired Dark Charcoal (`#121212`) & Emerald Green (`#1DB954`)

---

## 1. Application Name & Introduction
**TuneBox** is a modern, responsive, Spotify-inspired music player application designed for Desktop, Tablet, and Mobile web browsers. Built using Flutter and Dart, TuneBox delivers audio streaming, reactive state management using the Provider package, persistent playback controls across multiple screens, playlist CRUD functionality, 5-band frequency equalization, search filtering, and user profile management.

---

## 2. Purpose & Objectives
1. **Unified Cross-Platform UI**: Build a single Dart codebase running smoothly on Chrome, macOS, Windows, iOS, and Android.
2. **Spotify-Inspired Aesthetics**: Maintain clean typography, rounded card geometries, deep charcoal backgrounds (`#121212`), and high-contrast green accents (`#1DB954`).
3. **State Management Discipline**: Implement `ChangeNotifier` and `Provider` to maintain global audio playback state, queue management, liked tracks, and user playlists.
4. **Responsive Layouts**: Utilize `MediaQuery` and adaptive widgets (`NavigationRail`, `BottomNavigationBar`, `GridView.builder`, `ListView.builder`) across viewports.
5. **Form Validation**: Implement validated inputs with `GlobalKey<FormState>` and `TextFormField` validation.

---

## 3. Tools, Packages & Technologies
- **Flutter SDK**: 3.x (Web & Mobile targets)
- **Dart Language**: 3.x (Strong typing, null safety, async/await streams)
- **State Management**: `provider: ^6.1.1`
- **Audio Playback**: `audioplayers: ^5.2.1`
- **Typography**: `google_fonts: ^6.1.0` (Plus Jakarta Sans)
- **Image Caching**: `cached_network_image: ^3.3.1`
- **Build System**: Flutter Web Engine (CanvasKit & HTML/Wasm renderer)

---

## 4. System Architecture & Folder Hierarchy
```
tunebox/
├── pubspec.yaml                  # Dependencies, assets & metadata
├── README.md                     # Setup instructions & deployment
├── assets/
│   ├── images/                   # Album artwork & covers
│   └── audio/                    # Sample audio streams
└── lib/
    ├── main.dart                 # App entry, MultiProvider, Theme & Routes
    ├── models/
    │   ├── song.dart             # Song model with formatted duration
    │   ├── playlist.dart         # Playlist model with track lists
    │   └── user_profile.dart     # User profile model & statistics
    ├── providers/
    │   └── music_provider.dart   # ChangeNotifier with AudioPlayer & state
    ├── screens/
    │   ├── home_screen.dart      # Hero grid, categories, playlists, trending
    │   ├── search_screen.dart    # Search input, genre categories, results
    │   ├── library_screen.dart   # TabBar for playlists & liked songs
    │   ├── playlist_detail_screen.dart # Tracklist, play all, add/remove
    │   ├── player_screen.dart    # Fullscreen player with seekbar & lyrics
    │   ├── create_playlist_screen.dart # Validated form with GlobalKey
    │   ├── profile_screen.dart   # Avatar, statistics & profile editor
    │   └── settings_screen.dart  # 5-Band Equalizer, stream fidelity, cache
    └── widgets/
        ├── bottom_player.dart    # Persistent player with progress slider
        ├── song_card.dart        # Grid card with play overlay
        ├── song_row.dart         # List row with index and duration
        └── responsive_scaffold.dart # NavigationRail & BottomNavBar
```

---

## 5. Key Code Snippets with Explanations

### A. Central State Management with Provider (`lib/providers/music_provider.dart`)
```dart
class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;

  void playSong(Song song, [Playlist? playlist]) {
    _currentSong = song;
    _isPlaying = true;
    _position = Duration.zero;
    _audioPlayer.play(UrlSource(song.audioUrl));
    notifyListeners(); // Rebuilds only listening widgets
  }
}
```
*Explanation*: `MusicProvider` implements `ChangeNotifier`. When `notifyListeners()` is called, only the components wrapped with `context.watch<MusicProvider>()` re-render, preventing unnecessary rebuilds of the entire widget tree.

### B. Validated Form with GlobalKey (`lib/screens/create_playlist_screen.dart`)
```dart
final _formKey = GlobalKey<FormState>();

void _submit() {
  if (_formKey.currentState!.validate()) {
    context.read<MusicProvider>().createPlaylist(
      _nameController.text.trim(),
      _descController.text.trim(),
    );
    Navigator.pop(context);
  }
}
```
*Explanation*: Form fields check for input presence, minimum length (2 characters), and maximum length (50 characters).

### C. Responsive Scaffolding (`lib/widgets/responsive_scaffold.dart`)
```dart
final width = MediaQuery.of(context).size.width;
final isDesktop = width >= 1024;
final isTablet = width >= 640 && !isDesktop;
```
*Explanation*: Dynamically adapts between an extended `NavigationRail` for wide desktops and a compact `BottomNavigationBar` for mobile screens.

---

## 6. How to Run in VS Code
```bash
# 1. Fetch packages
flutter pub get

# 2. Run on Chrome
flutter run -d chrome

# 3. Build for Web Release
flutter build web --release
```

---

## 7. Deployment Details
- **GitHub Pages**: `flutter build web --base-href "/tunebox/" --release` followed by pushing `build/web` to the `gh-pages` branch.
- **Vercel**: Deploy the generated `build/web` static assets directly with `vercel build/web --prod`.
