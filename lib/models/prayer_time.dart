class PrayerTime {
  final String name;
  final DateTime time;
  final bool notificationEnabled;

  PrayerTime({
    required this.name,
    required this.time,
    this.notificationEnabled = true,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json, String name) {
    // Parse time string from API (format: HH:MM)
    final timeStr = json[name];
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    // Create DateTime object for today with the prayer time
    final now = DateTime.now();
    final time = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    return PrayerTime(
      name: name,
      time: time,
    );
  }

  // Convert to a format that can be stored in shared preferences
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time.toIso8601String(),
      'notificationEnabled': notificationEnabled,
    };
  }

  // Create a copy with modified properties
  PrayerTime copyWith({
    String? name,
    DateTime? time,
    bool? notificationEnabled,
  }) {
    return PrayerTime(
      name: name ?? this.name,
      time: time ?? this.time,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}

class DailyPrayerTimes {
  final DateTime date;
  final PrayerTime fajr;
  final PrayerTime sunrise;
  final PrayerTime dhuhr;
  final PrayerTime asr;
  final PrayerTime maghrib;
  final PrayerTime isha;

  DailyPrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory DailyPrayerTimes.fromJson(Map<String, dynamic> json) {
    final timings = json['data']['timings'];
    final date = DateTime.parse(json['data']['date']['gregorian']['date']);

    return DailyPrayerTimes(
      date: date,
      fajr: PrayerTime.fromJson(timings, 'Fajr'),
      sunrise: PrayerTime.fromJson(timings, 'Sunrise'),
      dhuhr: PrayerTime.fromJson(timings, 'Dhuhr'),
      asr: PrayerTime.fromJson(timings, 'Asr'),
      maghrib: PrayerTime.fromJson(timings, 'Maghrib'),
      isha: PrayerTime.fromJson(timings, 'Isha'),
    );
  }

  // Get the next prayer time from current time
  PrayerTime getNextPrayer() {
    final now = DateTime.now();
    final prayers = [fajr, sunrise, dhuhr, asr, maghrib, isha];
    
    // Filter prayers that are later than now
    final upcomingPrayers = prayers.where((prayer) => prayer.time.isAfter(now)).toList();
    
    if (upcomingPrayers.isEmpty) {
      // If no upcoming prayers today, return tomorrow's Fajr
      return fajr.copyWith(
        time: DateTime(now.year, now.month, now.day + 1, fajr.time.hour, fajr.time.minute),
      );
    }
    
    // Return the next upcoming prayer
    return upcomingPrayers.first;
  }

  // Get all prayers as a list
  List<PrayerTime> getAllPrayers() {
    return [fajr, sunrise, dhuhr, asr, maghrib, isha];
  }
}
