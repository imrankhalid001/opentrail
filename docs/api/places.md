# Wikipedia & Wikidata Integration Specs 🏛️

## Overview
Landmark descriptions, attraction summaries, and historical context are fetched dynamically from Wikipedia REST APIs.

- **Base Endpoint**: `https://en.wikipedia.org/api/rest_v1/page/summary/{title}`
- **Response Data**: Extracts `extract` (summary description), `thumbnail` (image URL), and `coordinates` (lat/long).
- **Attribution**: Displayed with standard "Source: Wikipedia (CC-BY-SA 3.0)" caption.
