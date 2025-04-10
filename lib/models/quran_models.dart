class Verse {
  final int number;
  final String arabicText;
  final String translation;
  final bool isFavorite;

  Verse({
    required this.number,
    required this.arabicText,
    required this.translation,
    this.isFavorite = false,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['number'],
      arabicText: json['arabicText'],
      translation: json['translation'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'arabicText': arabicText,
      'translation': translation,
      'isFavorite': isFavorite,
    };
  }

  Verse copyWith({
    int? number,
    String? arabicText,
    String? translation,
    bool? isFavorite,
  }) {
    return Verse(
      number: number ?? this.number,
      arabicText: arabicText ?? this.arabicText,
      translation: translation ?? this.translation,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class SurahDetail {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<Verse> verses;

  SurahDetail({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.verses,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    return SurahDetail(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      verses: (json['verses'] as List)
          .map((verse) => Verse.fromJson(verse))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'verses': verses.map((verse) => verse.toJson()).toList(),
    };
  }
}

class QuranVerse {
  final int surahNumber;
  final int verseNumber;
  final String arabicText;
  final String translation;
  final bool isFavorite;
  
  QuranVerse({
    required this.surahNumber,
    required this.verseNumber,
    required this.arabicText,
    required this.translation,
    this.isFavorite = false,
  });
  
  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      surahNumber: json['surahNumber'],
      verseNumber: json['verseNumber'],
      arabicText: json['arabicText'],
      translation: json['translation'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'verseNumber': verseNumber,
      'arabicText': arabicText,
      'translation': translation,
      'isFavorite': isFavorite,
    };
  }
  
  QuranVerse copyWith({
    int? surahNumber,
    int? verseNumber,
    String? arabicText,
    String? translation,
    bool? isFavorite,
  }) {
    return QuranVerse(
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      arabicText: arabicText ?? this.arabicText,
      translation: translation ?? this.translation,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;
  
  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });
  
  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
      revelationType: json['revelationType'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'numberOfAyahs': numberOfAyahs,
      'revelationType': revelationType,
    };
  }
}

class Hadith {
  final String collection;
  final String bookNumber;
  final String hadithNumber;
  final String englishText;
  final String arabicText;
  final String grade;
  
  Hadith({
    required this.collection,
    required this.bookNumber,
    required this.hadithNumber,
    required this.englishText,
    required this.arabicText,
    this.grade = '',
  });
  
  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      collection: json['collection'],
      bookNumber: json['bookNumber'],
      hadithNumber: json['hadithNumber'],
      englishText: json['englishText'],
      arabicText: json['arabicText'],
      grade: json['grade'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'collection': collection,
      'bookNumber': bookNumber,
      'hadithNumber': hadithNumber,
      'englishText': englishText,
      'arabicText': arabicText,
      'grade': grade,
    };
  }
}

class DailyContent {
  final QuranVerse verseOfTheDay;
  final Hadith hadithOfTheDay;
  final DateTime date;
  
  DailyContent({
    required this.verseOfTheDay,
    required this.hadithOfTheDay,
    required this.date,
  });
  
  factory DailyContent.fromJson(Map<String, dynamic> json) {
    return DailyContent(
      verseOfTheDay: QuranVerse.fromJson(json['verseOfTheDay']),
      hadithOfTheDay: Hadith.fromJson(json['hadithOfTheDay']),
      date: DateTime.parse(json['date']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'verseOfTheDay': verseOfTheDay.toJson(),
      'hadithOfTheDay': hadithOfTheDay.toJson(),
      'date': date.toIso8601String(),
    };
  }
}
