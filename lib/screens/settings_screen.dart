import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings & Audio Preferences',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text('Configure hardware equalization, crossfade, and audio fidelity', style: TextStyle(color: Colors.white54, fontSize: 12)),

              const SizedBox(height: 24),

              // Audio Quality Section
              _buildSectionCard(
                title: 'Streaming Fidelity & Playback',
                icon: Icons.volume_up,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Streaming Quality', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Higher bitrate delivers studio master depth', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    trailing: DropdownButton<String>(
                      value: provider.streamingQuality,
                      dropdownColor: const Color(0xFF242424),
                      style: const TextStyle(color: Color(0xFF1DB954), fontWeight: FontWeight.bold, fontSize: 13),
                      underline: const SizedBox.shrink(),
                      items: ['Lossless Hi-Fi', 'High (256 kbps)', 'Normal (128 kbps)']
                          .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) provider.setStreamingQuality(val);
                      },
                    ),
                  ),
                  const Divider(color: Colors.white10),
                  // Crossfade Slider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Crossfade Transitions', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('${provider.crossfadeSeconds}s', style: const TextStyle(color: Color(0xFF1DB954), fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                        ],
                      ),
                      Slider(
                        value: provider.crossfadeSeconds.toDouble(),
                        min: 0,
                        max: 12,
                        divisions: 12,
                        activeColor: const Color(0xFF1DB954),
                        inactiveColor: Colors.white24,
                        onChanged: (val) => provider.setCrossfade(val.toInt()),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Volume Normalization', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Set uniform loudness across all streaming audio tracks', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    activeColor: const Color(0xFF1DB954),
                    value: provider.normalizeVolume,
                    onChanged: (val) => provider.toggleNormalizeVolume(val),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 5-Band Equalizer Section
              _buildSectionCard(
                title: '5-Band Hardware Equalizer',
                icon: Icons.equalizer,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Preset', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Wrap(
                        spacing: 8,
                        children: ['Flat', 'Bass Boost', 'Electronic', 'Vocal Booster'].map((p) {
                          final isSelected = provider.eqPreset == p;
                          return ChoiceChip(
                            label: Text(p),
                            selected: isSelected,
                            selectedColor: const Color(0xFF1DB954),
                            backgroundColor: const Color(0xFF242424),
                            labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            onSelected: (_) => provider.setEqPreset(p),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sliders for 5 Bands
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: provider.equalizerBands.entries.map((entry) {
                      return Column(
                        children: [
                          Text('${entry.value > 0 ? "+" : ""}${entry.value.toInt()}dB', style: const TextStyle(fontSize: 10, color: Colors.white54, fontFamily: 'monospace')),
                          SizedBox(
                            height: 120,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                value: entry.value,
                                min: -12,
                                max: 12,
                                activeColor: const Color(0xFF1DB954),
                                inactiveColor: Colors.white12,
                                onChanged: (val) => provider.setEqualizerBand(entry.key, val),
                              ),
                            ),
                          ),
                          Text(entry.key, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Cache & App Info
              _buildSectionCard(
                title: 'Cache & Application',
                icon: Icons.info_outline,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Clear Local Audio Cache', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('Frees up 38.4 MB of cached audio samples', style: TextStyle(color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white12, foregroundColor: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Audio cache cleared!'), backgroundColor: Color(0xFF1DB954)),
                          );
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('TuneBox — Music Player App (Flutter Web Edition) v2.4.0', style: TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1DB954), size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
