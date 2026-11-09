class UserProfile {
  String name;
  String handle;
  String email;
  String avatarUrl;
  String bio;
  String favoriteGenre;
  int minutesListened;
  int songsPlayed;
  int streakDays;

  UserProfile({
    required this.name,
    required this.handle,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.favoriteGenre,
    required this.minutesListened,
    required this.songsPlayed,
    required this.streakDays,
  });
}
