import 'package:flutter/material.dart';
import 'package:quran_app/models/surah.dart';
import 'package:quran_app/services/favourite_service.dart';
import 'package:quran_app/services/quran_api_service.dart';
import 'package:quran_app/pages/surah_detail_page.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  FavouriteService? _favouriteService;
  final QuranApiService _apiService = QuranApiService();

  List<Surah> _allSurahs = [];
  List<Surah> _favouriteSurahs = [];
  List<_FavouriteAyahItem> _favouriteAyahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    setState(() => _isLoading = true);

    _favouriteService = await FavouriteService.getInstance();
    _allSurahs = await _apiService.getAllSurahs();

    // Get favourite surahs
    final favouriteSurahNumbers = _favouriteService!.getFavouriteSurahs();
    _favouriteSurahs = _allSurahs
        .where((surah) => favouriteSurahNumbers.contains(surah.number))
        .toList();

    // Get favourite ayahs with surah info
    final favouriteAyahKeys = _favouriteService!.getFavouriteAyahs();
    _favouriteAyahs = favouriteAyahKeys.map((key) {
      final parts = key.split(':');
      final surahNumber = int.parse(parts[0]);
      final ayahNumber = int.parse(parts[1]);
      final surah = _allSurahs.firstWhere((s) => s.number == surahNumber);
      return _FavouriteAyahItem(
        surah: surah,
        ayahNumber: ayahNumber,
      );
    }).toList();

    setState(() => _isLoading = false);
  }

  Future<void> _removeSurahFavourite(Surah surah) async {
    await _favouriteService?.toggleSurahFavourite(surah.number);
    setState(() {
      _favouriteSurahs.removeWhere((s) => s.number == surah.number);
    });
  }

  Future<void> _removeAyahFavourite(_FavouriteAyahItem item) async {
    await _favouriteService?.toggleAyahFavourite(item.surah.number, item.ayahNumber);
    setState(() {
      _favouriteAyahs.remove(item);
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
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD946A1),
                      ),
                    )
                  : _buildContent(),
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
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.favorite,
            color: Color(0xFFD946A1),
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Favourites',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_favouriteSurahs.isEmpty && _favouriteAyahs.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_favouriteSurahs.isNotEmpty) ...[
            _buildSectionHeader('Favourite Surahs', _favouriteSurahs.length),
            const SizedBox(height: 12),
            ..._favouriteSurahs.map((surah) => _buildSurahCard(surah)),
            const SizedBox(height: 24),
          ],
          if (_favouriteAyahs.isNotEmpty) ...[
            _buildSectionHeader('Favourite Ayahs', _favouriteAyahs.length),
            const SizedBox(height: 12),
            ..._favouriteAyahs.map((item) => _buildAyahCard(item)),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            color: Colors.white.withValues(alpha: 0.3),
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            'No favourites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding your favourite surahs\nand ayahs by tapping the heart icon',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD946A1).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD946A1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSurahCard(Surah surah) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailPage(surah: surah),
          ),
        ).then((_) => _loadFavourites()); // Refresh on return
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3D2045).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD946A1), Color(0xFF6B3070)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${surah.number}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.englishName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${surah.englishNameTranslation} - ${surah.numberOfAyahs} Ayahs',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              surah.name,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _removeSurahFavourite(surah),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFD946A1),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahCard(_FavouriteAyahItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailPage(surah: item.surah),
          ),
        ).then((_) => _loadFavourites()); // Refresh on return
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3D2045).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFD946A1).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${item.ayahNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD946A1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.surah.englishName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ayah ${item.ayahNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item.surah.name,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _removeAyahFavourite(item),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFD946A1),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavouriteAyahItem {
  final Surah surah;
  final int ayahNumber;

  _FavouriteAyahItem({
    required this.surah,
    required this.ayahNumber,
  });
}
