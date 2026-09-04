# Feature Map & Data Source Mapping 🗺️

This document maps OpenTrail's functional feature domains to their underlying services, local storage models, and primary open data sources.

| Feature Domain | Feature Components | Primary Open Data Source | Storage / Persistence | Release Target |
| :--- | :--- | :--- | :--- | :---: |
| **Explore** (`explore`) | Destination feed, trending spots, region filter, curated lists | RestCountries API, Wikidata | Memory Cache & SQLite | **MVP** |
| **Destinations** (`destinations`) | Country details, currency, language, emergency info, photos | RestCountries API, Wikipedia API | Drift SQLite | **MVP** |
| **Search** (`search`) | Global search across destinations, POIs, and saved trips | Nominatim Geocoding, Local DB | Drift SQLite | **MVP** |
| **Places** (`places`) | POI directory, category filter (culture, food, nature, transit) | OpenStreetMap, Overpass API | Drift SQLite | **MVP** |
| **Weather** (`weather`) | Live 7-day forecast, hourly graphs, monthly climate averages | Open-Meteo REST API | Drift SQLite | **MVP** |
| **Map** (`map`) | Vector tile map viewer, pan/zoom gestures, custom POI pins | OpenStreetMap Vector Tiles | Local Tile Cache & SQLite | **MVP** |
| **Trips** (`trips`) | Trip creation, date selection, countdown timer, expense log | Local User Input | Drift SQLite | **MVP** |
| **Favorites** (`favorites`) | Bookmark toggle for destinations, places, weather cards | Local User Input | Drift SQLite | **MVP** |
| **Settings** (`settings`) | Theme toggle (Light/Dark/System), language switcher, units | Local User Input | Shared Preferences | **MVP** |
| **Itinerary Builder** (`trips`) | Drag-and-drop daily timeline, route travel duration estimates | Local User Input + Nominatim | Drift SQLite | **Phase 2** |
| **Packing Lists** (`packing`) | Smart weather-tailored packing generator, item checklist | Local Generator + Open-Meteo | Drift SQLite | **Phase 2** |
| **Travel Stats** (`journey`) | Visited country counter, percentage world unlocked, map pins | Local User Input | Drift SQLite | **Phase 2** |
| **Achievements** (`journey`) | Milestone achievement badges, travel streak tracker | Local User Engine | Drift SQLite | **Phase 2** |
| **Offline Vector Maps** (`map`) | Offline map region downloading and offline tile management | OpenStreetMap Vector Tiles | Local Storage | **Phase 2** |
| **Encrypted Trip Export** (`trips`) | QR code trip export/import, peer-to-peer itinerary share | Local Cryptography | Local File / Camera | **Phase 3** |
