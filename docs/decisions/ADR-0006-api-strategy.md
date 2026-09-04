# ADR-0006: 100% Free & Open Data Provider Strategy

## Context
Commercial travel applications lock features behind paid APIs or pass vendor cost onto users via subscriptions. OpenTrail aims to remain an open-source, community-governed project with zero mandatory paid services.

## Decision
Use strictly 100% open, free public data sources: Open-Meteo (Weather), OpenStreetMap/Nominatim (Maps & Geocoding), Wikipedia REST API (Attractions), RestCountries (Country metadata).

## Alternatives Considered
1. *Google Places / Maps API*: Requires paid credit card setup and incurs recurring cost.
2. *WeatherAPI / DarkSky*: Closed commercial APIs with restrictive free tiers.

## Consequences
- Zero recurring API cost for maintainers and users.
- Privacy-friendly data access.
- Requires robust local caching to observe public rate limits.
