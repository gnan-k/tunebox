import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../models/user_profile.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Song? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 0.8;
  bool _isShuffle = false;
  String _repeatMode = 'off'; // 'off', 'all', 'one'
  final Set<String> _likedSongIds = {'song-1', 'song-2', 'song-4'};

  // Search & Filter state
  String _searchQuery = '';
  String? _selectedGenre;

  // Active Playlist
  Playlist? _activePlaylist;

  // Timer for smooth web duration ticking when testing mock audio
  Timer? _positionTimer;

  // Curated Mock Data
  final List<Song> _songs = [
    const Song(
      id: 'song-1',
      title: 'Neon Dreams',
      artist: 'The Electric Void',
      album: 'Synthwave Odyssey',
      duration: 214,
      coverUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=600&q=80',
      genre: 'Synthwave',
      releaseYear: 2026,
      lyrics: [
        'Gleaming neon reflections in the midnight rain',
        'Accelerating past the city limits on the highway lane',
        'The analog synthesizers pulse inside the mind',
        'Leaving all the static echoes far behind',
        'Cyan horizons meeting ultraviolet skies',
        'Caught within the timeless glow of your eyes',
      ],
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    const Song(
      id: 'song-2',
      title: 'Rainy Window Vibes',
      artist: 'Luna Café',
      album: 'Midnight Lo-Fi Sessions',
      duration: 172,
      coverUrl: 'https://images.unsplash.com/photo-1518495973542-4542c06a5843?auto=format&fit=crop&w=600&q=80',
      genre: 'Lo-Fi',
      releaseYear: 2026,
      lyrics: [
        'Steaming mug of black coffee by the open sill',
        'Gentle drops of rain cascading on the foggy hill',
        'Warm Rhodes piano chords warming up the room',
        'Dissolving every shadow of the afternoon gloom',
      ],
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
    const Song(
      id: 'song-3',
      title: 'Forest Hymns & The Mist',
      artist: 'Eli & The Pinewoods',
      album: 'Whispering Pines',
      duration: 236,
      coverUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=600&q=80',
      genre: 'Acoustic',
      releaseYear: 2025,
      lyrics: [
        'Walking down the gravel path where the cedars lean',
        'Breathing in the ancient morning cool and clean',
        'Acoustic strings vibrate against the wooden grain',
      ],
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    ),
    const Song(
      id: 'song-4',
      title: 'Harmonic Convergence',
      artist: 'Techno Electronica',
      album: 'Synthetic Echoes',
      duration: 248,
      coverUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80',
      genre: 'Techno',
      releaseYear: 2026,
      lyrics: [
        'Sub-bass resonance shaking through the floor',
        'Mechanical precision knocking at the door',
        'Laser beams converging at the center of the sphere',
      ],
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    ),
    const Song(
      id: 'song-5',
      title: 'Velvet Midnight Sax',
      artist: 'Miles Quartet',
      album: 'Late Night Sessions',
      duration: 198,
      coverUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
      genre: 'Jazz',
      releaseYear: 2025,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    ),
    const Song(
      id: 'song-6',
      title: 'Cyber Highway Run',
      artist: 'The Electric Void',
      album: 'Synthwave Odyssey',
      duration: 185,
      coverUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=600&q=80',
      genre: 'Synthwave',
      releaseYear: 2026,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
    ),
  ];

  final List<Playlist> _playlists = [
    Playlist(
      id: 'p1',
      name: "Today's Top Hits",
      description: 'The hottest tracks trending right now on TuneBox.',
      coverUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=600&q=80',
      songIds: ['song-1', 'song-4', 'song-2', 'song-6'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      colorHex: '0xFF0F5132',
    ),
    Playlist(
      id: 'p2',
      name: 'Chill Lo-Fi Cafe',
      description: 'Cozy study beats to relax, write, and code to.',
      coverUrl: 'https://images.unsplash.com/photo-1518495973542-4542c06a5843?auto=format&fit=crop&w=600&q=80',
      songIds: ['song-2', 'song-5'],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      colorHex: '0xFF854D0E',
    ),
    Playlist(
      id: 'p3',
      name: 'Synthwave Odyssey',
      description: 'Futuristic retrowave and 80s electronic driving vibes.',
      coverUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=600&q=80',
      songIds: ['song-1', 'song-6'],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      colorHex: '0xFF1E3A8A',
    ),
    Playlist(
      id: 'p4',
      name: 'Deep Focus & Code',
      description: 'Hypnotic modular techno and minimal electronica for flow.',
      coverUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80',
      songIds: ['song-4'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      colorHex: '0xFF064E3B',
    ),
  ];

  UserProfile _userProfile = UserProfile(
    name: 'Alex Rivera',
    handle: '@alexrivera',
    email: 'alex.rivera@tunebox.audio',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    bio: 'Music enthusiast, developer & audiophile. Always searching for new analog synth grooves and rainy lo-fi beats.',
    favoriteGenre: 'Synthwave',
    minutesListened: 14820,
    songsPlayed: 1248,
    streakDays: 18,
  );

  // Equalizer & Playback settings
  Map<String, double> _equalizerBands = {
    '60Hz': 4.0,
    '230Hz': 2.0,
    '910Hz': 0.0,
    '4kHz': 3.0,
    '14kHz': 5.0,
  };
  String _eqPreset = 'Electronic';
  int _crossfadeSeconds = 4;
  String _streamingQuality = 'Lossless Hi-Fi';
  bool _normalizeVolume = true;

  MusicProvider() {
    _currentSong = _songs.first;
    _duration = Duration(seconds: _currentSong!.duration);
    _initAudioListeners();
  }

  void _initAudioListeners() {
    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (_repeatMode == 'one') {
        seekTo(Duration.zero);
        _audioPlayer.resume();
      } else {
        nextSong();
      }
    });
  }

  // Getters
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  double get volume => _volume;
  bool get isShuffle => _isShuffle;
  String get repeatMode => _repeatMode;
  Set<String> get likedSongIds => _likedSongIds;
  List<Song> get songs => _songs;
  List<Playlist> get playlists => _playlists;
  UserProfile get userProfile => _userProfile;
  Playlist? get activePlaylist => _activePlaylist;
  String get searchQuery => _searchQuery;
  String? get selectedGenre => _selectedGenre;
  Map<String, double> get equalizerBands => _equalizerBands;
  String get eqPreset => _eqPreset;
  int get crossfadeSeconds => _crossfadeSeconds;
  String get streamingQuality => _streamingQuality;
  bool get normalizeVolume => _normalizeVolume;

  List<Song> get likedSongs => _songs.where((s) => _likedSongIds.contains(s.id)).toList();

  List<Song> get filteredSongs {
    return _songs.where((song) {
      final matchesGenre = _selectedGenre == null || song.genre.toLowerCase() == _selectedGenre!.toLowerCase();
      if (!matchesGenre) return false;
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return song.title.toLowerCase().contains(q) ||
          song.artist.toLowerCase().contains(q) ||
          song.album.toLowerCase().contains(q);
    }).toList();
  }

  // Playback Control Methods
  Future<void> playSong(Song song, [Playlist? playlist]) async {
    _currentSong = song;
    _activePlaylist = playlist;
    _duration = Duration(seconds: song.duration);
    _position = Duration.zero;
    _isPlaying = true;
    _userProfile.songsPlayed += 1;
    _userProfile.minutesListened += (song.duration ~/ 60);

    try {
      if (song.audioUrl.isNotEmpty && kIsWeb) {
        await _audioPlayer.play(UrlSource(song.audioUrl));
      }
    } catch (_) {
      // Graceful fallback for web security or offline sandboxes
    }

    _startSimulatedTicker();
    notifyListeners();
  }

  void _startSimulatedTicker() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlaying || _currentSong == null) {
        timer.cancel();
        return;
      }
      if (_position.inSeconds < _duration.inSeconds) {
        _position = Duration(seconds: _position.inSeconds + 1);
        notifyListeners();
      } else {
        timer.cancel();
        nextSong();
      }
    });
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      _audioPlayer.resume();
      _startSimulatedTicker();
    } else {
      _audioPlayer.pause();
      _positionTimer?.cancel();
    }
    notifyListeners();
  }

  void seekTo(Duration pos) {
    _position = pos;
    _audioPlayer.seek(pos);
    notifyListeners();
  }

  void nextSong() {
    if (_songs.isEmpty) return;
    int nextIdx;
    if (_isShuffle) {
      nextIdx = (DateTime.now().microsecond) % _songs.length;
    } else {
      final curIdx = _songs.indexOf(_currentSong!);
      nextIdx = (curIdx + 1) % _songs.length;
    }
    playSong(_songs[nextIdx], _activePlaylist);
  }

  void previousSong() {
    if (_songs.isEmpty) return;
    if (_position.inSeconds > 3) {
      seekTo(Duration.zero);
      return;
    }
    final curIdx = _songs.indexOf(_currentSong!);
    final prevIdx = curIdx > 0 ? curIdx - 1 : _songs.length - 1;
    playSong(_songs[prevIdx], _activePlaylist);
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    if (_repeatMode == 'off') {
      _repeatMode = 'all';
    } else if (_repeatMode == 'all') {
      _repeatMode = 'one';
    } else {
      _repeatMode = 'off';
    }
    notifyListeners();
  }

  void toggleLike(String songId) {
    if (_likedSongIds.contains(songId)) {
      _likedSongIds.remove(songId);
    } else {
      _likedSongIds.add(songId);
    }
    notifyListeners();
  }

  void setVolume(double val) {
    _volume = val.clamp(0.0, 1.0);
    _audioPlayer.setVolume(_volume);
    notifyListeners();
  }

  // Playlist Management CRUD
  String createPlaylist(String name, String description, [String colorHex = '0xFF1DB954']) {
    final newId = 'pl_${DateTime.now().millisecondsSinceEpoch}';
    final playlist = Playlist(
      id: newId,
      name: name,
      description: description,
      coverUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=600&q=80',
      songIds: [],
      isCustom: true,
      createdAt: DateTime.now(),
      colorHex: colorHex,
    );
    _playlists.insert(0, playlist);
    notifyListeners();
    return newId;
  }

  void deletePlaylist(String playlistId) {
    _playlists.removeWhere((p) => p.id == playlistId);
    if (_activePlaylist?.id == playlistId) {
      _activePlaylist = null;
    }
    notifyListeners();
  }

  void addSongToPlaylist(String playlistId, String songId) {
    final pl = _playlists.firstWhere((p) => p.id == playlistId);
    if (!pl.songIds.contains(songId)) {
      pl.songIds.add(songId);
      notifyListeners();
    }
  }

  void removeSongFromPlaylist(String playlistId, String songId) {
    final pl = _playlists.firstWhere((p) => p.id == playlistId);
    pl.songIds.remove(songId);
    notifyListeners();
  }

  // Search & Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedGenre(String? genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  void setActivePlaylist(Playlist playlist) {
    _activePlaylist = playlist;
    notifyListeners();
  }

  // User Profile
  void updateProfile({required String name, required String bio, required String favoriteGenre}) {
    _userProfile.name = name;
    _userProfile.bio = bio;
    _userProfile.favoriteGenre = favoriteGenre;
    notifyListeners();
  }

  // Equalizer & Settings
  void setEqualizerBand(String band, double value) {
    _equalizerBands[band] = value;
    _eqPreset = 'Custom';
    notifyListeners();
  }

  void setEqPreset(String preset) {
    _eqPreset = preset;
    if (preset == 'Bass Boost') {
      _equalizerBands = {'60Hz': 8.0, '230Hz': 5.0, '910Hz': 1.0, '4kHz': 0.0, '14kHz': 1.0};
    } else if (preset == 'Electronic') {
      _equalizerBands = {'60Hz': 4.0, '230Hz': 2.0, '910Hz': 0.0, '4kHz': 3.0, '14kHz': 5.0};
    } else if (preset == 'Vocal Booster') {
      _equalizerBands = {'60Hz': -2.0, '230Hz': 1.0, '910Hz': 5.0, '4kHz': 3.0, '14kHz': 1.0};
    } else {
      _equalizerBands = {'60Hz': 0.0, '230Hz': 0.0, '910Hz': 0.0, '4kHz': 0.0, '14kHz': 0.0};
    }
    notifyListeners();
  }

  void setCrossfade(int seconds) {
    _crossfadeSeconds = seconds;
    notifyListeners();
  }

  void setStreamingQuality(String quality) {
    _streamingQuality = quality;
    notifyListeners();
  }

  void toggleNormalizeVolume(bool val) {
    _normalizeVolume = val;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
