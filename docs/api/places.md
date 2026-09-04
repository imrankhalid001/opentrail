# Wikipedia & Wikidata Integration 🏛️

OpenTrail uses **Wikipedia API** and **Wikimedia Commons** for landmark summaries, cultural descriptions, and photo galleries.

## Services & Endpoints
- **Summary API**: `https://en.wikipedia.org/api/rest_v1/page/summary/{title}`
- **Landmark Images**: Wikimedia Commons API.
- **Authentication**: None required.
- **Caching & Offline**: Summaries cached in Drift SQLite for 7 days; images cached in disk memory for 30 days.
- **Attribution**: "Content from Wikipedia (CC-BY-SA 3.0)".
