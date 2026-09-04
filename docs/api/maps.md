# OpenStreetMap & Nominatim Geocoding Specs 🗺️

## Tile Server
- **Tile URL Template**: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- **Tile Caching**: Raster and vector map tiles are cached locally in SQLite/disk storage for offline rendering.

---

## Geocoding & Search (Nominatim)
- **Base Endpoint**: `https://nominatim.openstreetmap.org/search`
- **Parameters**: `q={query}&format=json&limit=10`
- **User-Agent Requirement**: Nominatim requires a valid HTTP `User-Agent` header (`OpenTrail-FlutterApp/1.0`).
- **Throttling**: Requests are debounced by 500ms and limited to max 1 call per second.
