import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_time.dart';

class PrayerTimeService {
  // Base URL for AlAdhan API
  static const String baseUrl = 'https://api.aladhan.com/v1';
  
  // Default calculation method (8 = Gulf Region)
  static const int defaultMethod = 8;
  
  // Cache key for storing prayer times
  static const String cacheKey = 'cached_prayer_times';
  
  // Get prayer times for the current location
  Future<DailyPrayerTimes> getPrayerTimes() async {
    try {
      // Get current position
      final position = await _getCurrentPosition();
      
      // Check if we have cached prayer times for today
      final cachedTimes = await _getCachedPrayerTimes();
      if (cachedTimes != null) {
        return cachedTimes;
      }
      
      // Fetch prayer times from API
      final url = '$baseUrl/timings/${_getFormattedDate()}?latitude=${position.latitude}&longitude=${position.longitude}&method=$defaultMethod';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prayerTimes = DailyPrayerTimes.fromJson(data);
        
        // Cache the prayer times
        await _cachePrayerTimes(response.body);
        
        return prayerTimes;
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting prayer times: $e');
    }
  }
  
  // Get prayer times for a specific date
  Future<DailyPrayerTimes> getPrayerTimesForDate(DateTime date) async {
    try {
      // Get current position
      final position = await _getCurrentPosition();
      
      // Format date as DD-MM-YYYY
      final formattedDate = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
      
      // Fetch prayer times from API
      final url = '$baseUrl/timings/$formattedDate?latitude=${position.latitude}&longitude=${position.longitude}&method=$defaultMethod';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DailyPrayerTimes.fromJson(data);
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting prayer times: $e');
    }
  }
  
  // Get prayer times for a specific location
  Future<DailyPrayerTimes> getPrayerTimesForLocation(double latitude, double longitude) async {
    try {
      // Fetch prayer times from API
      final url = '$baseUrl/timings/${_getFormattedDate()}?latitude=$latitude&longitude=$longitude&method=$defaultMethod';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DailyPrayerTimes.fromJson(data);
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting prayer times: $e');
    }
  }
  
  // Get current position
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }
    
    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    
    // Get current position
    return await Geolocator.getCurrentPosition();
  }
  
  // Get formatted date for API (DD-MM-YYYY)
  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
  }
  
  // Cache prayer times
  Future<void> _cachePrayerTimes(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey, data);
  }
  
  // Get cached prayer times
  Future<DailyPrayerTimes?> _getCachedPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(cacheKey);
    
    if (cachedData != null) {
      final data = json.decode(cachedData);
      final cachedDate = DateTime.parse(data['data']['date']['gregorian']['date']);
      final today = DateTime.now();
      
      // Check if cached data is from today
      if (cachedDate.year == today.year && 
          cachedDate.month == today.month && 
          cachedDate.day == today.day) {
        return DailyPrayerTimes.fromJson(data);
      }
    }
    
    return null;
  }
}
