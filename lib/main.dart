import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartoon Kids TV Shows',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const IndexPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ─────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────

class Show {
  final String name;
  final String tagline;
  final String emoji;
  final List<Color> gradientColors;
  final double imageHeight;

  const Show({
    required this.name,
    required this.tagline,
    required this.emoji,
    required this.gradientColors,
    required this.imageHeight,
  });
}

const List<Show> shows = [
  Show(
    name: 'Upin & Ipin',
    tagline: 'Malaysian twin brothers',
    emoji: '👬',
    gradientColors: [Color(0xFFFDE047), Color(0xFFFB923C)],
    imageHeight: 150,
  ),
  Show(
    name: 'Boboiboy',
    tagline: 'Elemental superhero',
    emoji: '⚡',
    gradientColors: [Color(0xFFFB923C), Color(0xFFEF4444)],
    imageHeight: 150,
  ),
  Show(
    name: 'Ejen Ali',
    tagline: 'Young secret agent',
    emoji: '🕶️',
    gradientColors: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
    imageHeight: 150,
  ),
  Show(
    name: 'Didi & Friends',
    tagline: 'Singing little chicks',
    emoji: '🐥',
    gradientColors: [Color(0xFFF9A8D4), Color(0xFFFB7185)],
    imageHeight: 150,
  ),
  Show(
    name: 'Omar & Hana',
    tagline: 'Islamic nasheed kids',
    emoji: '🌙',
    gradientColors: [Color(0xFF6EE7B7), Color(0xFF14B8A6)],
    imageHeight: 150,
  ),
  Show(
    name: 'Pada Zaman Dahulu',
    tagline: 'Animal folk tales',
    emoji: '🦁',
    gradientColors: [Color(0xFFFBBF24), Color(0xFFEAB308)],
    imageHeight: 150,
  ),
];

const String storageKey = 'cartoon-show-images';
const int maxSize = 5 * 1024 * 1024;

// ─────────────────────────────────────────
// INDEX PAGE
// ─────────────────────────────────────────

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Map<String, String> images = {};
  String? error;
  bool _loading = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(storageKey);
      if (saved != null && saved.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(saved);
        final valid = <String, String>{};
        for (final entry in decoded.entries) {
          if (await File(entry.value.toString()).exists()) {
            valid[entry.key] = entry.value.toString();
          }
        }
        setState(() => images = valid);
      }
    } catch (_) {
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _persist(Map<String, String> next) async {
    setState(() => images = next);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(storageKey, jsonEncode(next));
    } catch (_) {
      setState(() => error = 'Storage full — try removing some images.');
    }
  }

  Future<void> _openPicker(String showName) async {
    setState(() => error = null);
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (picked == null) return;

      final nameLower = picked.name.toLowerCase();
      final extOk = RegExp(r'\.(jpe?g|png)$').hasMatch(nameLower);
      if (!extOk) {
        setState(() => error = 'Only JPG, JPEG, or PNG files are allowed.');
        return;
      }

      final fileSize = await File(picked.path).length();
      if (fileSize > maxSize) {
        setState(() => error = 'Image must be under 5MB.');
        return;
      }

      final newImages = Map<String, String>.from(images);
      newImages[showName] = picked.path;
      await _persist(newImages);
    } catch (_) {
      setState(() => error = 'Failed to read file.');
    }
  }

  Future<void> _removeImage(String showName) async {
    final newImages = Map<String, String>.from(images);
    newImages.remove(showName);
    await _persist(newImages);
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ───────────────────────────
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
              child: const Text(
                'Siri Kartun Kanak-Kanak',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // ── Error banner ──────────────────────
            if (error != null)
              Container(
                margin:
                const EdgeInsets.fromLTRB(16, 0, 16, 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red[700], size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(error!,
                          style:
                          TextStyle(color: Colors.red[700])),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => error = null),
                      child: Icon(Icons.close,
                          color: Colors.red[400], size: 18),
                    ),
                  ],
                ),
              ),

            // ── Masonry Grid ──────────────────────
            // Uses MasonryGridView.builder — works on all 0.7.x versions
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: MasonryGridView.builder(
                  gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: shows.length,
                  itemBuilder: (context, index) {
                    final show = shows[index];
                    final imagePath = images[show.name];
                    return _ShowCard(
                      show: show,
                      imagePath: imagePath,
                      onTap: () => _openPicker(show.name),
                      onRemove: () => _removeImage(show.name),
                    );
                  },
                ),
              ),
            ),

            // ── Footer ────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 4),
              child: Text(
                'Tap a card to upload · .jpg .jpeg .png · Max 5MB',
                style: TextStyle(
                    fontSize: 11, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// SHOW CARD
// ─────────────────────────────────────────

class _ShowCard extends StatelessWidget {
  final Show show;
  final String? imagePath;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _ShowCard({
    required this.show,
    required this.imagePath,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Image / Gradient ──────────────────
            Stack(
              children: [
                Container(
                  height: show.imageHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: show.gradientColors,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: imagePath != null
                      ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: show.imageHeight,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(show.emoji,
                            style: const TextStyle(
                                fontSize: 52)),
                      ),
                    ),
                  )
                      : Center(
                    child: Text(
                      show.emoji,
                      style: const TextStyle(fontSize: 52),
                    ),
                  ),
                ),

                // Upload badge
                if (imagePath == null)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'UPLOAD',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                // Remove button
                if (imagePath != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'REMOVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ── Text ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    show.tagline,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}