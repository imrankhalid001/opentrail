# Open-Meteo Weather Integration Specs 🌤️

## Overview
Open-Meteo provides accurate open-source weather forecasts without requiring API keys.

- **Base Endpoint**: `https://api.open-meteo.com/v1/forecast`
- **Method**: `GET`
- **Parameters**:
  - `latitude`: Decimal (e.g. `35.6762`)
  - `longitude`: Decimal (e.g. `139.6503`)
  - `hourly`: `temperature_2m,relative_humidity_2m,precipitation_probability,weather_code`
  - `daily`: `temperature_2m_max,temperature_2m_min,uv_index_max`
  - `timezone`: `auto`

---

## Caching & Rate Limit Compliance
- OpenTrail caches Open-Meteo JSON responses in SQLite for **1 hour** to minimize server load.
- Exponential backoff is applied if rate limit HTTP 429 status codes are encountered.
