# EPIC-001: Call Quran API and display list of surah in the homepage. Make sure the interface is beautiful

## Scope
Integrate with the Al-Quran Cloud API to fetch all 114 surahs and display them in a beautiful, scrollable list on the home page. The interface features a modern dark green theme with gradient cards, Arabic surah names with gold accents, and a cohesive design across the landing and home pages.

## Tickets

| ID | Description | Status |
|----|-------------|--------|
| T-001 | Create Surah model class | done |
| T-002 | Create QuranApiService to fetch surahs from API | done |
| T-003 | Update SurahCard widget with dynamic data and beautiful styling | done |
| T-004 | Update HomePage with API integration and surah list | done |
| T-005 | Improve overall UI styling (landing page, home page, color scheme) | done |

## Implementation Summary

### Files Created
- `lib/models/surah.dart` - Surah data model
- `lib/services/quran_api_service.dart` - API service for fetching surahs

### Files Modified
- `lib/main.dart` - Fixed theme configuration
- `lib/pages/home_page.dart` - Complete redesign with API integration
- `lib/pages/landing_page.dart` - Updated with new design
- `lib/widgets/home_page_widgets.dart` - SurahCard with dynamic data
- `lib/widgets/landing_page_widgets.dart` - Improved styling

### API Used
- Al-Quran Cloud API: `https://api.alquran.cloud/v1/surah`

### Features
- Fetches all 114 surahs from the API
- Displays surah number, English name, translation, Arabic name, and ayah count
- Shows revelation type (Meccan/Medinan) with icons
- Loading state with spinner
- Error handling with retry button
- Last read card placeholder
- Search icon placeholder for future implementation
