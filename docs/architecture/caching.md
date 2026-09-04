# Caching Policy & Cache Invalidation Matrix 💾

OpenTrail uses a multi-tier caching policy to minimize network bandwidth, maximize offline responsiveness, and preserve device battery life.

---

## 1. Multi-Tier Cache Matrix

| Data Domain | Storage Medium | Time-To-Live (TTL) | Invalidation / Eviction Policy |
| :--- | :--- | :---: | :--- |
| **Weather Forecasts** | Drift SQLite (`cached_api_responses`) | 1 Hour | Auto-expire after TTL; manual pull-to-refresh override |
| **Destination Intelligence** | Drift SQLite (`destinations`) | 7 Days | Auto-expire after TTL; background revalidate when online |
| **Places / Attractions** | Drift SQLite (`places`) | 14 Days | Auto-expire after TTL; background revalidate when online |
| **User Trips & Itineraries** | Drift SQLite (`trips`, `itinerary_items`) | Permanent | User explicit creation, modification, or deletion |
| **Packing Checklists** | Drift SQLite (`packing_items`) | Permanent | User explicit modification or deletion |
| **Favorites & Bookmarks** | Drift SQLite (`favorites`) | Permanent | User explicit toggle |
| **Landmark Photos & Media** | HTTP Disk Cache (`cached_network_image`) | 30 Days | LRU (Least Recently Used) disk space cache eviction |
| **Map Vector Tiles** | Local Storage Vector Tile Cache | Permanent / Manual | Pre-downloaded region management; LRU tile cache |

---

## 2. Cache Invalidation Engine Implementation

The repository evaluates entry timestamps before making remote REST API network requests:

```dart
Future<Result<WeatherData, AppException>> getWeather(double lat, double lon) async {
  final cacheKey = 'weather_${lat}_$lon';
  final cached = await database.getCachedApiResponse(cacheKey);

  // 1. Check if cached data exists and is unexpired
  if (cached != null && !cached.isExpired(const Duration(hours: 1))) {
    return Success(WeatherData.fromJson(jsonDecode(cached.jsonPayload)));
  }

  // 2. If online, fetch fresh remote weather payload
  if (await networkInfo.isConnected) {
    try {
      final remoteData = await remoteService.getWeather(lat, lon);
      await database.saveCachedApiResponse(cacheKey, jsonEncode(remoteData.toJson()));
      return Success(remoteData);
    } catch (e) {
      // Fallback to stale cache if remote request fails
      if (cached != null) {
        return Success(WeatherData.fromJson(jsonDecode(cached.jsonPayload)));
      }
      return Failure(NetworkException('Failed to load weather forecast', cause: e));
    }
  }

  // 3. If offline, return cached data if available
  if (cached != null) {
    return Success(WeatherData.fromJson(jsonDecode(cached.jsonPayload)));
  }

  return const Failure(NetworkException('You are offline and no cached weather is available.'));
}
```
