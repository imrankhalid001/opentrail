# REST Countries Integration Specs 🌍

## Overview
Country metadata (flag SVG, population, region, capital city, official languages, currency codes) is retrieved from REST Countries.

- **Endpoint**: `https://restcountries.com/v3.1/all?fields=name,capital,region,languages,currencies,flags,latlng`
- **Method**: `GET`
- **Caching**: Full dataset is cached locally in SQLite for 30 days.
