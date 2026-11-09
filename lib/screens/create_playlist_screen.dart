import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class CreatePlaylistScreen extends StatefulWidget {
  const CreatePlaylistScreen({super.key});

  @override
  State<CreatePlaylistScreen> createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedColor = '0xFF1DB954';

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Emerald', 'hex': '0xFF1DB954', 'color': Color(0xFF1DB954)},
    {'name': 'Violet', 'hex': '0xFF6366F1', 'color': Color(0xFF6366F1)},
    {'name': 'Amber', 'hex': '0xFFF59E0B', 'color': Color(0xFFF59E0B)},
    {'name': 'Teal', 'hex': '0xFF14B8A6', 'color': Color(0xFF14B8A6)},
    {'name': 'Rose', 'hex': '0xFFF43F5E', 'color': Color(0xFFF43F5E)},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<MusicProvider>().createPlaylist(
            _nameController.text.trim(),
            _descController.text.trim(),
            _selectedColor,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Playlist created successfully!'),
          backgroundColor: Color(0xFF1DB954),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Create Playlist', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form Header Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Color(int.parse(_selectedColor)).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.music_note, size: 36, color: Color(int.parse(_selectedColor))),
                  ),
                  const SizedBox(height: 24),

                  // Name Field with Form Validation
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Playlist Name *',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintText: 'e.g. Midnight Coding Grooves',
                      hintStyle: TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: Color(0xFF1E1E1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Color(0xFF1DB954), width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a playlist name';
                      }
                      if (val.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      if (val.trim().length > 50) {
                        return 'Name cannot exceed 50 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Description Field
                  TextFormField(
                    controller: _descController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintText: 'Give your playlist an evocative description...',
                      hintStyle: TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: Color(0xFF1E1E1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Color(0xFF1DB954), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Color Picker
                  const Text('Select Atmosphere Color', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _colors.map((c) {
                      final isSelected = _selectedColor == c['hex'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = c['hex']),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: c['color'],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _submit,
                    child: const Text('Save Playlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
