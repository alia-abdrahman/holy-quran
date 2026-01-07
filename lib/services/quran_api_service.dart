import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quran_app/models/ayah.dart';
import 'package:quran_app/models/surah.dart';

class QuranApiService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  Future<List<Surah>> getAllSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/surah'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> surahList = jsonData['data'];
      return surahList.map((json) => Surah.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    final responses = await Future.wait([
      http.get(Uri.parse('$baseUrl/surah/$surahNumber')),
      http.get(Uri.parse('$baseUrl/surah/$surahNumber/en.sahih')),
    ]);
    final arabicResponse = responses[0];
    final tafsirResponse = responses[1];

    if (arabicResponse.statusCode == 200) {
      final Map<String, dynamic> arabicData = json.decode(arabicResponse.body);
      final List<dynamic> ayahList = arabicData['data']['ayahs'];

      Map<int, String> tafsirMap = {};
      if (tafsirResponse.statusCode == 200) {
        final Map<String, dynamic> tafsirData = json.decode(tafsirResponse.body);
        final List<dynamic> tafsirList = tafsirData['data']['ayahs'];
        for (var tafsir in tafsirList) {
          tafsirMap[tafsir['numberInSurah']] = tafsir['text'];
        }
      }

      return ayahList.map((json) {
        final numberInSurah = json['numberInSurah'] as int;
        return Ayah.fromJson(json, tafsirText: tafsirMap[numberInSurah]);
      }).toList();
    } else {
      throw Exception('Failed to load ayahs');
    }
  }
}
