import 'package:flutter/material.dart';
import '../models/quran_models.dart';
import '../services/quran_service.dart';

class QuranBrowserScreen extends StatefulWidget {
  const QuranBrowserScreen({super.key});

  @override
  State<QuranBrowserScreen> createState() => _QuranBrowserScreenState();
}

class _QuranBrowserScreenState extends State<QuranBrowserScreen> {
  final QuranService _quranService = QuranService();
  List<Surah> _surahs = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final surahs = await _quranService.getAllSurahs();
      
      setState(() {
        _surahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading surahs: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSurahs,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_surahs.isEmpty) {
      return const Center(
        child: Text('No surahs available'),
      );
    }

    return ListView.builder(
      itemCount: _surahs.length,
      itemBuilder: (context, index) {
        final surah = _surahs[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: Text(surah.number.toString()),
          ),
          title: Text(surah.englishName),
          subtitle: Text('${surah.englishNameTranslation} • ${surah.numberOfAyahs} verses'),
          trailing: Text(
            surah.name,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Amiri',
            ),
            textDirection: TextDirection.rtl,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurahDetailScreen(surah: surah),
              ),
            );
          },
        );
      },
    );
  }
}

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final QuranService _quranService = QuranService();
  List<Verse> _verses = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final edition = _selectedLanguage == 'tr' ? 'tr.yazir' : 'en.asad';
      final surahDetail = await _quranService.getSurah(widget.surah.number, edition: edition);
      
      setState(() {
        _verses = surahDetail.verses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading surah: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.englishName),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (language) {
              setState(() {
                _selectedLanguage = language;
              });
              _loadVerses();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'tr',
                child: Text('Turkish'),
              ),
              const PopupMenuItem(
                value: 'en',
                child: Text('English'),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadVerses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_verses.isEmpty) {
      return const Center(
        child: Text('No verses available'),
      );
    }

    return ListView.builder(
      itemCount: _verses.length + 1, // +1 for the bismillah header
      itemBuilder: (context, index) {
        if (index == 0) {
          // Bismillah header (except for Surah 9)
          if (widget.surah.number != 9) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Amiri',
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'In the name of Allah, the Most Gracious, the Most Merciful',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 32),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final verse = _verses[index - 1]; // Adjust for bismillah header
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      child: Text(verse.number.toString()),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {
                            // TODO: Implement bookmark functionality
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            // TODO: Implement share functionality
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  verse.arabicText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Amiri',
                    height: 1.5,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                const Divider(height: 32),
                Text(
                  verse.translation,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
