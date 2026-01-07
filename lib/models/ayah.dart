class Ayah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int page;
  final bool sajda;
  final String? tafsir;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.page,
    required this.sajda,
    this.tafsir,
  });

  factory Ayah.fromJson(Map<String, dynamic> json, {String? tafsirText}) {
    return Ayah(
      number: json['number'],
      text: json['text'],
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      page: json['page'],
      sajda: json['sajda'] == true || json['sajda'] is Map,
      tafsir: tafsirText,
    );
  }

  Ayah copyWith({String? tafsir}) {
    return Ayah(
      number: number,
      text: text,
      numberInSurah: numberInSurah,
      juz: juz,
      page: page,
      sajda: sajda,
      tafsir: tafsir ?? this.tafsir,
    );
  }
}
