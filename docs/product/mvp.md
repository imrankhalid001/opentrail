# MVP Scope Boundaries 🎯

To prevent feature creep, maintain rapid delivery cycles, and preserve architectural quality, OpenTrail enforces strict scope boundaries across product releases.

---

## 🎯 In-Scope for MVP (Foundation & Milestones 1–3)

### 1. Engineering Foundation & Design System (Phase 0)
- Feature-first MVVM directory layout with Riverpod state management and GoRouter routing.
- Reusable UI component strategy (`AppButton`, `AppCard`, `AppTextField`, `AppSearchBar`, `AppSkeleton`, `AppErrorState`, `AppEmptyState`, `AppFavoriteButton`, `AppRating`, `AppChip`, `AppBadge`).
- Material 3 theme system (Light, Dark, System Theme) and 4-language localization setup (English, Urdu, Arabic RTL, Japanese).

### 2. Destination Intelligence (`explore` & `destinations`)
- Destination discovery feed with regional filtering (RestCountries API).
- Comprehensive detail screens with cultural facts, currency, emergency phone numbers, and landmark photo galleries (Wikipedia API).

### 3. Live & Climate Weather (`weather`)
- Live 7-day weather forecasting, hourly temperature curves, UV index, and precipitation indicators (Open-Meteo REST API).
- Monthly climate averages for travel planning.

### 4. Interactive Maps & POI Search (`map` & `places`)
- OpenStreetMap vector tile map viewer with pan, zoom, and location centering.
- Categorized POI discovery (culture, natural, dining, transit) using Nominatim geocoding.

### 5. Basic Trip Management (`trips` & `favorites`)
- Create and manage basic travel trips with start/end dates.
- Bookmark destinations, places, and weather locations to local Drift SQLite database.

---

## 🚀 Post-MVP Scope (Phase 2)

- **Drag-and-Drop Itinerary Builder**: Reorder daily activities interactively with automated travel duration calculation.
- **Smart Packing List Generator**: Automated weather-driven checklist generation based on destination forecast.
- **Travel Statistics & Achievements**: Visited country counter, percentage of world unlocked, and milestone badges.
- **Offline Map Region Downloader**: Pre-download vector map tiles for full offline navigation.

---

## 🔮 Future / Experimental Scope (Phase 3+)

- **Encrypted QR Trip Sharing**: Peer-to-peer trip itinerary export and import using QR codes or local Wi-Fi.
- **GPX Route Tracking & Elevation Profiles**: Track hiking trails and render elevation graphs locally.
