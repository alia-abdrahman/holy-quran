# EPIC-002: Add the page where user able to view the verses of surah clicked

## Scope
Create a beautiful surah detail page that displays all verses (ayahs) when a user taps on a surah from the home page list. The page shows the surah header with Arabic name, English name, translation, revelation type, and ayah count, followed by a scrollable list of all verses with their Arabic text.

## Tickets

| ID | Description | Status |
|----|-------------|--------|
| T-001 | Create Ayah model class | done |
| T-002 | Add API method to fetch surah verses | done |
| T-003 | Create SurahDetailPage to display verses | done |
| T-004 | Update SurahCard to navigate to detail page | done |
| T-005 | Style the verses display beautifully | done |

## Implementation Summary

### Files Created
- `lib/models/ayah.dart` - Ayah data model with number, text, juz, page, sajda properties
- `lib/pages/surah_detail_page.dart` - Beautiful surah detail page with:
  - Custom sliver app bar with back button and bookmark icon
  - Surah header card with Arabic name, English name, translation
  - Revelation type and ayah count badges
  - Bismillah display (except for Surah At-Tawbah)
  - Scrollable list of ayah cards

### Files Modified
- `lib/services/quran_api_service.dart` - Added `getSurahAyahs(surahNumber)` method
- `lib/widgets/home_page_widgets.dart` - Added navigation to SurahDetailPage on tap

### API Used
- Al-Quran Cloud API: `https://api.alquran.cloud/v1/surah/{surahNumber}`

### Features
- Fetches all ayahs for selected surah
- Displays ayah number badge with action icons (play, bookmark, share)
- Shows Arabic text with proper RTL alignment
- Displays Juz and Page number for each ayah
- Special "Sajda" badge for prostration verses
- Loading state with spinner
- Error handling with retry button
- Smooth scrolling with slivers
