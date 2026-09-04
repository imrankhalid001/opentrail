# Localization & Multi-Language Strategy 🌐

OpenTrail is engineered for worldwide accessibility with full support for Left-to-Right (LTR) and Right-to-Left (RTL) locales.

## Supported Locales in Foundation
- `en`: English (Base Locale)
- `ur`: Urdu (RTL)
- `ar`: Arabic (RTL)
- `ja`: Japanese

---

## ARB File Workflow
All user-facing text strings reside in `lib/l10n/app_<locale>.arb` files.

```json
{
  "appTitle": "OpenTrail",
  "@appTitle": {
    "description": "Main title of the application"
  },
  "exploreTitle": "Discover Destinations",
  "weatherForecastTitle": "Weather Forecast",
  "retryButton": "Retry",
  "emptyStateTitle": "No Results Found"
}
```

Never hardcode string literals inside Flutter widget trees!
