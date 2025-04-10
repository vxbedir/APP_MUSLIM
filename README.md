# Islamic Lifestyle App

A comprehensive Islamic lifestyle application providing essential tools for daily Islamic practices.

## Features

- **Prayer Times**: Accurate prayer times based on your location with customizable notifications
- **Qibla Direction**: Compass pointing towards Mecca for prayer direction
- **Daily Content**: Verse of the Day and Hadith of the Day for daily inspiration
- **Quran Browser**: Complete Quran with Arabic text and translations
- **Salah Guidance**: Step-by-step prayer instructions with visual guidance
- **Dhikr Counter**: Digital tasbeeh counter for tracking dhikr repetitions

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter plugins
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/islamic-lifestyle-app.git
```

2. Navigate to the project directory
```bash
cd islamic-lifestyle-app
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Building the App

### Android

To build an APK:
```bash
flutter build apk
```

The APK file will be located at `build/app/outputs/flutter-apk/app-release.apk`

### iOS

To build for iOS (requires macOS):
```bash
flutter build ios
```

Then open the Xcode project in the `ios` folder and archive it for distribution.

## Project Structure

- `lib/models/` - Data models
- `lib/screens/` - UI screens
- `lib/services/` - Business logic and API services
- `lib/utils/` - Utility functions and helpers
- `lib/widgets/` - Reusable UI components

## Dependencies

- `flutter_compass` - For Qibla direction
- `geolocator` - For location services
- `http` - For API requests
- `sqflite` - For local database
- `shared_preferences` - For storing user preferences
- `flutter_local_notifications` - For prayer time notifications

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Quran API provided by [Alquran.cloud](https://alquran.cloud/api)
- Prayer time calculations based on standard astronomical algorithms
#   A P P _ M U S L I M  
 