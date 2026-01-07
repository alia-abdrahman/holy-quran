import 'package:flutter/material.dart';
import 'package:quran_app/models/ayah.dart';
import 'package:quran_app/models/surah.dart';
import 'package:quran_app/services/quran_api_service.dart';
import 'package:quran_app/services/favourite_service.dart';

class SurahDetailPage extends StatefulWidget {
  final Surah surah;

  const SurahDetailPage({super.key, required this.surah});

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late Future<List<Ayah>> _ayahsFuture;
  final QuranApiService _apiService = QuranApiService();

  // Favourite state
  FavouriteService? _favouriteService;
  bool _isSurahFavourite = false;
  Set<String> _favouriteAyahs = {};

  @override
  void initState() {
    super.initState();
    _ayahsFuture = _apiService.getSurahAyahs(widget.surah.number);
    _initFavourites();
  }

  Future<void> _initFavourites() async {
    _favouriteService = await FavouriteService.getInstance();
    setState(() {
      _isSurahFavourite = _favouriteService!.isSurahFavourite(widget.surah.number);
      _favouriteAyahs = _favouriteService!.getFavouriteAyahs();
    });
  }

  Future<void> _toggleSurahFavourite() async {
    await _favouriteService?.toggleSurahFavourite(widget.surah.number);
    setState(() {
      _isSurahFavourite = !_isSurahFavourite;
    });
  }

  Future<void> _toggleAyahFavourite(int ayahNumber) async {
    await _favouriteService?.toggleAyahFavourite(widget.surah.number, ayahNumber);
    setState(() {
      final key = '${widget.surah.number}:$ayahNumber';
      if (_favouriteAyahs.contains(key)) {
        _favouriteAyahs.remove(key);
      } else {
        _favouriteAyahs.add(key);
      }
    });
  }

  bool _isAyahFavourite(int ayahNumber) {
    return _favouriteAyahs.contains('${widget.surah.number}:$ayahNumber');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F1C),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSurahHeader(),
          _buildAyahsList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFF1A0F1C),
      expandedHeight: 0,
      floating: true,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // T-006: Favourite heart icon for surah
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isSurahFavourite ? Icons.favorite : Icons.favorite_border,
              color: _isSurahFavourite ? const Color(0xFFD946A1) : Colors.white,
              size: 18,
            ),
          ),
          onPressed: _toggleSurahFavourite,
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bookmark_border, color: Colors.white, size: 18),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSurahHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD946A1), Color(0xFF3D2045)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD946A1).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              widget.surah.name,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.surah.englishName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.surah.englishNameTranslation,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.surah.revelationType == 'Meccan'
                        ? Icons.mosque
                        : Icons.location_city,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.surah.revelationType,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.format_list_numbered,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.surah.numberOfAyahs} Ayahs',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
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

  Widget _buildAyahsList() {
    return FutureBuilder<List<Ayah>>(
      future: _ayahsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD946A1),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load ayahs',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _ayahsFuture = _apiService.getSurahAyahs(widget.surah.number);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD946A1),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final ayahs = snapshot.data!;
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final ayah = ayahs[index];
                return _buildAyahCard(ayah);
              },
              childCount: ayahs.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAyahCard(Ayah ayah) {
    final isFavourite = _isAyahFavourite(ayah.numberInSurah);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2045).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFD946A1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${ayah.numberInSurah}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  _buildActionIcon(Icons.play_arrow_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  // T-007: Favourite heart icon for ayah
                  _buildActionIcon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    onTap: () => _toggleAyahFavourite(ayah.numberInSurah),
                    isActive: isFavourite,
                  ),
                  const SizedBox(width: 8),
                  _buildActionIcon(Icons.bookmark_border, onTap: () {}),
                  const SizedBox(width: 8),
                  _buildActionIcon(Icons.share_outlined, onTap: () {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            ayah.text,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.white,
              height: 2.2,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          if (ayah.tafsir != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ayah.tafsir!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.6,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Juz ${ayah.juz}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Page ${ayah.page}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              if (ayah.sajda) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Sajda',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, {VoidCallback? onTap, bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? const Color(0xFFD946A1) : Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
