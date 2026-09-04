# OpenStreetMap & Nominatim Specification 🗺️

OpenTrail uses **OpenStreetMap** vector tiles for interactive map rendering and **Nominatim** for geocoding and points of interest (POI) discovery.

## Services & Endpoints
- **Tile Server**: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- **Geocoding & POI Search**: `https://nominatim.openstreetmap.org/search?q={query}&format=jsonv2`
- **Authentication**: None required (custom User-Agent header required).
- **Rate Limits**: Nominatim enforces maximum 1 request per second per IP.
- **Caching & Offline**: Map tiles cached locally on disk; POI search cached in SQLite.
- **Attribution**: "© OpenStreetMap contributors (ODbL)".
