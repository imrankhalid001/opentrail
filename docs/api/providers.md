# Evaluated Open Data Providers 🌐

OpenTrail depends exclusively on free, open, public data sources with zero mandatory API key requirements or commercial paywalls.

| Provider | Purpose | Primary Endpoints | Rate Limits | License | Decision |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **Open-Meteo** | Live weather forecasts & historical climate | `/v1/forecast`, `/v1/climate` | 10,000 daily calls (Free) | CC-BY 4.0 | **SELECTED** |
| **OpenStreetMap** | Vector map tiles & POI geocoding | `tile.openstreetmap.org`, Nominatim | 1 req/sec (Nominatim) | ODbL / CC-BY-SA | **SELECTED** |
| **Wikipedia & Wikidata** | Cultural summaries, landmarks, photo galleries | `/w/api.php`, Wikidata SPARQL | Open / Reasonable attribution | CC-BY-SA 3.0 | **SELECTED** |
| **RestCountries** | Country metadata, currencies, capitals | `/v3.1/all`, `/v3.1/alpha/{code}` | Open | MIT / Public Domain | **SELECTED** |
| **Frankfurter API** | Public currency exchange rates | `/latest`, `/{date}` | Open | MIT / Public Data | **SELECTED** |
