<p align="center">
  <img src="assets/images/quran-icon.webp" alt="Quran App Logo" width="120"/>
</p>

<h1 align="center">Quran App</h1>

<p align="center">
  <strong>بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ</strong>
  <br/>
  <em>In the name of Allah, the Most Gracious, the Most Merciful</em>
</p>

<p align="center">
  A beautiful and intuitive mobile application for reading the Holy Quran, built with Flutter.
</p>

---

## Features

- **Complete Quran** - Access all 114 Surahs of the Holy Quran
- **Arabic Text** - Beautiful Arabic script with proper formatting
- **English Translation** - Clear English translations for each Ayah
- **Surah Information** - View details including Meccan/Medinan revelation and Ayah count
- **Favourites** - Mark your favourite Surahs and Ayahs for quick access
- **Last Read** - Automatically tracks your reading progress
- **Beautiful UI** - Elegant Islamic-inspired design with calming colours

## Screenshots

<p align="center">
  <img src="screenshots/home_page.png" alt="Home Page" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="screenshots/surah_detail.png" alt="Surah Detail" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="screenshots/ayah_view.png" alt="Ayah View" width="250"/>
</p>

## Getting Started

### Prerequisites

- Flutter SDK (^3.10.1)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/quran_app.git
   ```

2. Navigate to the project directory
   ```bash
   cd quran_app
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run the app
   ```bash
   flutter run
   ```

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **API**: [Al-Quran Cloud API](https://alquran.cloud/api)
- **State Management**: StatefulWidget
- **Local Storage**: SharedPreferences

## Project Structure

```
lib/
├── main.dart              # App entry point
├── palette.dart           # Colour definitions
├── models/
│   ├── surah.dart         # Surah data model
│   └── ayah.dart          # Ayah data model
├── pages/
│   ├── landing_page.dart  # Landing/splash screen
│   ├── home_page.dart     # Main Surah list
│   ├── surah_detail_page.dart  # Surah reading view
│   └── favourite_page.dart     # Favourites screen
├── services/
│   ├── quran_api_service.dart  # API integration
│   └── favourite_service.dart  # Favourites persistence
└── widgets/
    ├── landing_page_widgets.dart
    └── home_page_widgets.dart
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).

---

<p align="center">
  <strong>جَزَاكَ اللَّهُ خَيْرًا</strong>
  <br/>
  <em>May Allah reward you with goodness</em>
</p>
