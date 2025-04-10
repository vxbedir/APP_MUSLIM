import 'package:flutter/material.dart';
import 'screens/prayer_times_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/daily_content_screen.dart';
import 'screens/quran_browser_screen.dart';
import 'screens/salah_guidance_screen.dart';
import 'screens/dhikr_counter_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const IslamicLifestyleApp());
}

class IslamicLifestyleApp extends StatelessWidget {
  const IslamicLifestyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Lifestyle',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const PrayerTimesScreen(),
    const QiblaScreen(),
    const DailyContentScreen(),
    const QuranBrowserScreen(),
    const SalahGuidanceScreen(),
    const DhikrCounterScreen(),
  ];
  
  final List<String> _titles = [
    'Prayer Times',
    'Qibla Direction',
    'Daily Inspiration',
    'Quran Browser',
    'Salah Guidance',
    'DhikrMatic',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Prayer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Qibla',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Salah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Dhikr',
          ),
        ],
      ),
    );
  }
}
