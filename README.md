# TuneBox — Music Player App (Flutter Web)

A Spotify-inspired, responsive dark-mode music player app built with Flutter and Dart.

## Faculty Requirements Implemented
1. **Appropriate Flutter Widgets**: Container, Row, Column, Stack, ListView.builder, GridView.builder, Card, IconButton, and ElevatedButton.
2. **Responsive Design**: Adapts for Mobile (<640px), Tablet (640px-1023px), and Desktop (>=1024px) using `MediaQuery`.
3. **Screen Navigation**: Multi-screen navigation with declarative named routes.
4. **State Management**: Implemented using `ChangeNotifier` and `Provider` (single source of truth).
5. **Interactive Controls**: Play, pause, seekbar, next, previous, shuffle, repeat, and 5-band equalizer.
6. **Form Validation**: `GlobalKey<FormState>` and `TextFormField` validation for playlist creation.
7. **Complete Deliverables**: Source code, documentation report, viva questions & answers, VS Code instructions, and deployment steps.

## How to Run in VS Code
```bash
# 1. Install dependencies
flutter pub get

# 2. Run on Chrome
flutter run -d chrome

# 3. Build for web deployment
flutter build web --release
```

## GitHub Commands
```bash
git init
git add .
git commit -m "feat: complete TuneBox Flutter Web music player app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/tunebox.git
git push -u origin main
```

## Deployment to Vercel / GitHub Pages
- **GitHub Pages**: `flutter build web --base-href "/tunebox/" --release` -> `npx gh-pages -d build/web`
- **Vercel**: `flutter build web --release` -> `vercel build/web --prod`
