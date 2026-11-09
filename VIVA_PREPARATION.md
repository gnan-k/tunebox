# TuneBox — Faculty Viva Examination Preparation Guide

This guide prepares you to answer faculty questions about Flutter widgets, reactive state management, audio streaming, responsive layouts, and performance optimization.

---

### Q1. What is Flutter, and why is it preferred for TuneBox Web development?
**Answer**:
Flutter is Google's open-source UI software development kit. It compiles a single Dart codebase into native ARM machine code for mobile and desktop, or standard Web technologies (HTML5, CSS, CanvasKit, WebGL, WebAssembly) for browsers. In TuneBox, Flutter provides:
- Single codebase targeting Desktop, Tablet, and Mobile.
- Hot Reload for fast UI iteration.
- Consistent 60fps graphic rendering across browsers.

---

### Q2. Explain the difference between StatelessWidget and StatefulWidget.
**Answer**:
- **StatelessWidget** (e.g., `SongCard`, `SongRow`): Immutable widgets whose UI configuration depends strictly on the parameters passed during instantiation. They do not maintain internal mutable state across frames.
- **StatefulWidget** (e.g., `HomeScreen`, `CreatePlaylistScreen`, `SearchScreen`): Accompanied by a persistent `State` object. Calling `setState()` notifies the Flutter framework that the state has changed, scheduling a rebuild of the widget's subtree.

---

### Q3. How does state management work in TuneBox?
**Answer**:
TuneBox implements the **Provider** package with `ChangeNotifier` (`MusicProvider`):
1. **Single Source of Truth**: Audio playback state, volume, track duration, liked songs, and playlist CRUD operations are managed inside `MusicProvider`.
2. **Reactivity**: When a user clicks Play or creates a playlist, `notifyListeners()` is invoked.
3. **Selective Rebuilding**: Widgets using `context.watch<MusicProvider>()` re-render only when relevant data changes, avoiding unnecessary full widget-tree redraws.

---

### Q4. How does TuneBox achieve responsive design?
**Answer**:
TuneBox evaluates viewport dimensions via `MediaQuery.of(context).size.width`:
- **Desktop (>= 1024px)**: Uses an extended `NavigationRail` with persistent side navigation and 4-5 column `GridView` layouts.
- **Tablet (640px - 1023px)**: Condenses `NavigationRail` to an icon rail and scales grid columns to 2-3.
- **Mobile (< 640px)**: Hides side rail, displays a bottom `BottomNavigationBar`, and presents a single-column layout.

---

### Q5. What core Flutter widgets were used and why?
**Answer**:
- `Container`: Layout constraints, gradient headers, borders, and margins.
- `Row` & `Column`: Horizontal and vertical linear flexbox arrangement.
- `Stack`: Overlaying play/pause buttons on top of album artwork.
- `ListView.builder`: Lazy-loading long tracklists without memory overhead.
- `GridView.builder`: Displaying albums, genres, and playlists in responsive grids.
- `Card` & `IconButton`: Material Design tactile surfaces with ripple feedback.
- `SliderTheme` & `Slider`: Scrubbable audio progress bar and volume control.
- `Form` & `TextFormField`: Validated text input fields with real-time error messages.

---

### Q6. How is form validation implemented in `CreatePlaylistScreen`?
**Answer**:
We assign a `GlobalKey<FormState>()` to the `Form` widget:
```dart
final _formKey = GlobalKey<FormState>();

if (_formKey.currentState!.validate()) {
  // Executed only if all validator functions return null (no error)
}
```
Each `TextFormField` has a `validator` callback checking if input is non-empty and between 2 and 50 characters.

---

### Q7. How does audio playback and progress tracking work?
**Answer**:
We utilize the `audioplayers` package. The `AudioPlayer` exposes event streams:
- `onPositionChanged`: Emits current playback `Duration`.
- `onDurationChanged`: Emits total audio file length.
- `onPlayerComplete`: Triggers playback of the next track in the queue or loops if repeat is enabled.

---

### Q8. What is the benefit of `const` constructors?
**Answer**:
Marking widget constructors with `const` (e.g., `const SizedBox(height: 16)`) signals the Dart compiler to allocate the widget at compile-time and reuse the same memory instance, avoiding garbage collection overhead during rebuilds.

---

### Q9. How do you deploy TuneBox Flutter Web to production?
**Answer**:
Execute `flutter build web --release`. This compiles Dart into optimized JavaScript and WebAssembly in `build/web/`. The generated bundle can be hosted on GitHub Pages or Vercel.
