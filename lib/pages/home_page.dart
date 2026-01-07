import 'package:flutter/material.dart';
import 'package:quran_app/models/surah.dart';
import 'package:quran_app/services/quran_api_service.dart';
import 'package:quran_app/widgets/home_page_widgets.dart';
import 'package:quran_app/pages/favourite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Surah>> _surahsFuture;
  final QuranApiService _apiService = QuranApiService();

  // Search state
  final TextEditingController _searchController = TextEditingController();
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _surahsFuture = _apiService.getAllSurahs();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterSurahs(_searchController.text);
  }

  /// Normalizes text for phonetic matching of Arabic transliterations.
  /// Handles variations like "fatiha" matching "Al-Faatiha".
  String _normalizeForSearch(String text) {
    String normalized = text.toLowerCase();

    // Remove common prefixes
    normalized = normalized.replaceAll(RegExp(r'^al-?'), '');

    // Normalize double vowels to single (faatiha → fatiha)
    normalized = normalized.replaceAll('aa', 'a');
    normalized = normalized.replaceAll('ee', 'i'); // ee → i (yaseen → yasin)
    normalized = normalized.replaceAll('ii', 'i');
    normalized = normalized.replaceAll('oo', 'u'); // oo → u
    normalized = normalized.replaceAll('uu', 'u');

    // Normalize e/i interchange (common in Arabic transliteration)
    // yaseen/yasin,een/in are the same sound
    normalized = normalized.replaceAll('e', 'i');

    // Normalize common Arabic transliteration variations
    normalized = normalized.replaceAll("'", '');  // Remove apostrophes (Qur'an → Quran)
    normalized = normalized.replaceAll('-', '');   // Remove hyphens
    normalized = normalized.replaceAll('dh', 'd'); // Adh-Dhariyat → Ad-Dariyat
    normalized = normalized.replaceAll('th', 't'); // Common variation
    normalized = normalized.replaceAll('kh', 'k'); // Common variation
    normalized = normalized.replaceAll('gh', 'g'); // Common variation
    normalized = normalized.replaceAll('sh', 's'); // Shura → Sura

    return normalized;
  }

  void _filterSurahs(String query) {
    if (_allSurahs.isEmpty) return;

    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = List.from(_allSurahs);
      } else {
        final normalizedQuery = _normalizeForSearch(query);
        _filteredSurahs = _allSurahs.where((surah) {
          // Check exact match first (for number search)
          final lowerQuery = query.toLowerCase();
          if (surah.number.toString().contains(lowerQuery)) {
            return true;
          }

          // Check Arabic name (exact match)
          if (surah.name.contains(query)) {
            return true;
          }

          // Phonetic matching for English names
          final normalizedEnglishName = _normalizeForSearch(surah.englishName);
          final normalizedTranslation = _normalizeForSearch(surah.englishNameTranslation);

          return normalizedEnglishName.contains(normalizedQuery) ||
              normalizedTranslation.contains(normalizedQuery);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredSurahs = List.from(_allSurahs);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F1C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildLastReadCard(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Surah',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _buildSurahList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!_isSearching) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assalamualaikum',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ] else ...[
            Expanded(
              child: _buildSearchField(),
            ),
            const SizedBox(width: 12),
          ],
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavouritePage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xFFD946A1),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _toggleSearch,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isSearching
                        ? const Color(0xFFD946A1).withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isSearching ? Icons.close : Icons.search,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD946A1).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search surah...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 16,
          ),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.5),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildLastReadCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD946A1), Color(0xFF3D2045)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD946A1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last Read',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Al-Fatihah',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Surah No: 1',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/quran-icon.webp',
            height: 100,
            width: 100,
            fit: BoxFit.contain,
            opacity: const AlwaysStoppedAnimation(0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahList() {
    return FutureBuilder<List<Surah>>(
      future: _surahsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD946A1),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white.withOpacity(0.5),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load surahs',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _surahsFuture = _apiService.getAllSurahs();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D5A),
                  ),
                  child: Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        // Initialize surahs list on first successful load
        if (_allSurahs.isEmpty && snapshot.hasData) {
          _allSurahs = snapshot.data!;
          _filteredSurahs = List.from(_allSurahs);
        }

        final surahs = _isSearching ? _filteredSurahs : _allSurahs;

        if (surahs.isEmpty && _isSearching) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  color: Colors.white.withOpacity(0.5),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'No surah found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            return SurahCard(surah: surahs[index]);
          },
        );
      },
    );
  }
}
