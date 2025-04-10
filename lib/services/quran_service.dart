import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quran_models.dart';

class QuranService {
  // Cache keys
  static const String surahsCacheKey = 'quran_surahs';
  static const String verseOfTheDayCacheKey = 'verse_of_the_day';
  static const String hadithOfTheDayCacheKey = 'hadith_of_the_day';
  
  // API endpoints
  static const String quranApiBaseUrl = 'https://api.alquran.cloud/v1';
  
  // Get all surahs
  Future<List<Surah>> getAllSurahs() async {
    try {
      // Check if we have cached surahs
      final cachedSurahs = await _getCachedSurahs();
      if (cachedSurahs.isNotEmpty) {
        return cachedSurahs;
      }
      
      // If not cached, fetch from API
      final response = await http.get(Uri.parse('$quranApiBaseUrl/surah'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> surahsData = data['data'];
        
        final surahs = surahsData.map((surahData) => Surah.fromJson(surahData)).toList();
        
        // Cache the surahs
        await _cacheSurahs(surahs);
        
        return surahs;
      } else {
        throw Exception('Failed to load surahs');
      }
    } catch (e) {
      throw Exception('Error getting surahs: $e');
    }
  }
  
  // Get a specific surah with translation
  Future<SurahDetail> getSurah(int surahNumber, {String edition = 'en.asad'}) async {
    try {
      // Fetch Arabic text
      final arabicResponse = await http.get(
        Uri.parse('$quranApiBaseUrl/surah/$surahNumber/ar.alafasy')
      );
      
      // Fetch translation
      final translationResponse = await http.get(
        Uri.parse('$quranApiBaseUrl/surah/$surahNumber/$edition')
      );
      
      if (arabicResponse.statusCode == 200 && translationResponse.statusCode == 200) {
        final arabicData = jsonDecode(arabicResponse.body)['data'];
        final translationData = jsonDecode(translationResponse.body)['data'];
        
        final List<dynamic> arabicAyahs = arabicData['ayahs'];
        final List<dynamic> translationAyahs = translationData['ayahs'];
        
        final List<Verse> verses = [];
        
        for (int i = 0; i < arabicAyahs.length; i++) {
          verses.add(Verse(
            number: arabicAyahs[i]['numberInSurah'],
            arabicText: arabicAyahs[i]['text'],
            translation: translationAyahs[i]['text'],
          ));
        }
        
        return SurahDetail(
          number: arabicData['number'],
          name: arabicData['name'],
          englishName: arabicData['englishName'],
          englishNameTranslation: arabicData['englishNameTranslation'],
          revelationType: arabicData['revelationType'],
          verses: verses,
        );
      } else {
        throw Exception('Failed to load surah');
      }
    } catch (e) {
      throw Exception('Error getting surah: $e');
    }
  }
  
  // Get verse of the day
  Future<QuranVerse> getVerseOfTheDay() async {
    try {
      // Check if we already have a verse for today
      final cachedVerse = await _getCachedVerseOfTheDay();
      if (cachedVerse != null) {
        return cachedVerse;
      }
      
      // Generate a random surah and verse
      final random = Random();
      final surahNumber = random.nextInt(114) + 1; // 1-114
      
      // Get the surah to find out how many verses it has
      final surah = await getSurah(surahNumber);
      final verseNumber = random.nextInt(surah.verses.length) + 1;
      
      // Get the specific verse
      final arabicResponse = await http.get(
        Uri.parse('$quranApiBaseUrl/ayah/$surahNumber:$verseNumber/ar.alafasy')
      );
      
      final translationResponse = await http.get(
        Uri.parse('$quranApiBaseUrl/ayah/$surahNumber:$verseNumber/en.asad')
      );
      
      if (arabicResponse.statusCode == 200 && translationResponse.statusCode == 200) {
        final arabicData = jsonDecode(arabicResponse.body)['data'];
        final translationData = jsonDecode(translationResponse.body)['data'];
        
        final verse = QuranVerse(
          surahNumber: surahNumber,
          verseNumber: verseNumber,
          arabicText: arabicData['text'],
          translation: translationData['text'],
        );
        
        // Cache the verse of the day
        await _cacheVerseOfTheDay(verse);
        
        return verse;
      } else {
        throw Exception('Failed to load verse of the day');
      }
    } catch (e) {
      throw Exception('Error getting verse of the day: $e');
    }
  }
  
  // Get hadith of the day (simplified as we don't have a real Hadith API in this example)
  Future<Hadith> getHadithOfTheDay() async {
    try {
      // Check if we already have a hadith for today
      final cachedHadith = await _getCachedHadithOfTheDay();
      if (cachedHadith != null) {
        return cachedHadith;
      }
      
      // In a real app, this would call a Hadith API
      // For this example, we'll use a predefined list of hadiths
      final hadiths = [
        Hadith(
          collection: 'Bukhari',
          bookNumber: '1',
          hadithNumber: '1',
          englishText: 'The reward of deeds depends upon the intentions and every person will get the reward according to what he has intended.',
          arabicText: 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
          grade: 'Sahih',
        ),
        Hadith(
          collection: 'Muslim',
          bookNumber: '1',
          hadithNumber: '1',
          englishText: 'Whoever introduces a good practice in Islam will have its reward and the reward of whoever acts upon it after him without any decrease in their rewards.',
          arabicText: 'من سن في الإسلام سنة حسنة فله أجرها وأجر من عمل بها بعده من غير أن ينقص من أجورهم شيء',
          grade: 'Sahih',
        ),
        Hadith(
          collection: 'Tirmidhi',
          bookNumber: '1',
          hadithNumber: '1',
          englishText: 'The most beloved of deeds to Allah are the most consistent ones, even if they are small.',
          arabicText: 'أحب الأعمال إلى الله أدومها وإن قل',
          grade: 'Sahih',
        ),
      ];
      
      final random = Random();
      final hadith = hadiths[random.nextInt(hadiths.length)];
      
      // Cache the hadith of the day
      await _cacheHadithOfTheDay(hadith);
      
      return hadith;
    } catch (e) {
      throw Exception('Error getting hadith of the day: $e');
    }
  }
  
  // Get daily content (verse and hadith)
  Future<DailyContent> getDailyContent() async {
    final verse = await getVerseOfTheDay();
    final hadith = await getHadithOfTheDay();
    
    return DailyContent(
      verseOfTheDay: verse,
      hadithOfTheDay: hadith,
      date: DateTime.now(),
    );
  }
  
  // Cache surahs
  Future<void> _cacheSurahs(List<Surah> surahs) async {
    final prefs = await SharedPreferences.getInstance();
    final surahsJson = surahs.map((surah) => jsonEncode(surah.toJson())).toList();
    await prefs.setStringList(surahsCacheKey, surahsJson);
  }
  
  // Get cached surahs
  Future<List<Surah>> _getCachedSurahs() async {
    final prefs = await SharedPreferences.getInstance();
    final surahsJson = prefs.getStringList(surahsCacheKey);
    
    if (surahsJson != null) {
      return surahsJson
          .map((surahJson) => Surah.fromJson(jsonDecode(surahJson)))
          .toList();
    }
    
    return [];
  }
  
  // Cache verse of the day
  Future<void> _cacheVerseOfTheDay(QuranVerse verse) async {
    final prefs = await SharedPreferences.getInstance();
    final verseJson = jsonEncode(verse.toJson());
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    
    await prefs.setString('$verseOfTheDayCacheKey-$dateKey', verseJson);
  }
  
  // Get cached verse of the day
  Future<QuranVerse?> _getCachedVerseOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    final verseJson = prefs.getString('$verseOfTheDayCacheKey-$dateKey');
    
    if (verseJson != null) {
      return QuranVerse.fromJson(jsonDecode(verseJson));
    }
    
    return null;
  }
  
  // Cache hadith of the day
  Future<void> _cacheHadithOfTheDay(Hadith hadith) async {
    final prefs = await SharedPreferences.getInstance();
    final hadithJson = jsonEncode(hadith.toJson());
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    
    await prefs.setString('$hadithOfTheDayCacheKey-$dateKey', hadithJson);
  }
  
  // Get cached hadith of the day
  Future<Hadith?> _getCachedHadithOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    final hadithJson = prefs.getString('$hadithOfTheDayCacheKey-$dateKey');
    
    if (hadithJson != null) {
      return Hadith.fromJson(jsonDecode(hadithJson));
    }
    
    return null;
  }
}
