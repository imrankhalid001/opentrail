# Open-Meteo Weather API Specification 🌤️

OpenTrail integrates **Open-Meteo** for global weather forecasts and historical climate metrics.

## Endpoint & Parameters
- **Base URL**: `https://api.open-meteo.com/v1/forecast`
- **Parameters**: `latitude`, `longitude`, `hourly=temperature_2m,relative_humidity_2m,precipitation_probability`, `daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max`
- **Authentication**: None required.
- **Rate Limits**: 10,000 daily requests per IP address.
- **Caching & Offline**: Responses cached in Drift SQLite for 1 hour.
- **Attribution Requirement**: "Weather data powered by Open-Meteo (CC-BY 4.0)".
