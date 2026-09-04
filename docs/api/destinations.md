# REST Countries API Specification 🌍

OpenTrail integrates **RestCountries API** for destination discovery feeds, country metadata, languages, currencies, and capital cities.

## Services & Endpoints
- **All Countries**: `https://restcountries.com/v3.1/all`
- **Country by Code**: `https://restcountries.com/v3.1/alpha/{code}`
- **Authentication**: None required.
- **Caching & Offline**: Country dataset cached in Drift SQLite for 7 days.
- **Attribution**: "Country data provided by REST Countries".
