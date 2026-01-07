import 'package:shared_preferences/shared_preferences.dart';

class FavouriteService {
  static const String _favouriteSurahsKey = 'favourite_surahs';
  static const String _favouriteAyahsKey = 'favourite_ayahs';

  static FavouriteService? _instance;
  static SharedPreferences? _prefs;

  FavouriteService._();

  static Future<FavouriteService> getInstance() async {
    _instance ??= FavouriteService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Surah favourites
  Set<int> getFavouriteSurahs() {
    final list = _prefs?.getStringList(_favouriteSurahsKey) ?? [];
    return list.map((e) => int.parse(e)).toSet();
  }

  bool isSurahFavourite(int surahNumber) {
    return getFavouriteSurahs().contains(surahNumber);
  }

  Future<void> toggleSurahFavourite(int surahNumber) async {
    final favourites = getFavouriteSurahs();
    if (favourites.contains(surahNumber)) {
      favourites.remove(surahNumber);
    } else {
      favourites.add(surahNumber);
    }
    await _prefs?.setStringList(
      _favouriteSurahsKey,
      favourites.map((e) => e.toString()).toList(),
    );
  }

  // Ayah favourites (stored as "surahNumber:ayahNumber")
  Set<String> getFavouriteAyahs() {
    return (_prefs?.getStringList(_favouriteAyahsKey) ?? []).toSet();
  }

  bool isAyahFavourite(int surahNumber, int ayahNumber) {
    final key = '$surahNumber:$ayahNumber';
    return getFavouriteAyahs().contains(key);
  }

  Future<void> toggleAyahFavourite(int surahNumber, int ayahNumber) async {
    final key = '$surahNumber:$ayahNumber';
    final favourites = getFavouriteAyahs();
    if (favourites.contains(key)) {
      favourites.remove(key);
    } else {
      favourites.add(key);
    }
    await _prefs?.setStringList(
      _favouriteAyahsKey,
      favourites.toList(),
    );
  }
}
