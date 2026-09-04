# User Journeys 🚀

This document details the primary end-to-end interaction flows across OpenTrail's core user personas.

---

## Journey 1: Destination Discovery & Weather-Aware Planning (Alex — Solo Backpacker)

```
[Open Application]
       │
       ▼
[Browse Explore Feed] ───> [Apply Region Filter: East Asia]
                                │
                                ▼
                     [Select Destination: Tokyo]
                                │
                                ▼
                     [Inspect Weather & Climate]
                                │
                                ▼
                     [Tap "Create Trip Plan"]
                                │
                                ▼
                     [Save Trip to Local SQLite]
```

1. **Discovery**: Alex launches OpenTrail and applies the "East Asia" region filter on the Explore feed.
2. **Inspection**: Alex selects "Tokyo" to review cultural facts, currency conversion, emergency numbers, and the 7-day weather forecast powered by Open-Meteo.
3. **Planning**: Alex creates a new trip ("Tokyo Backpacking 2027") with trip start and end dates.
4. **Offline Persistence**: OpenTrail automatically caches destination details, weather metrics, and maps to Drift SQLite for offline access on the road.

---

## Journey 2: Offline Exploration & POI Search (Omar — Digital Nomad)

```
[Enable Airplane Mode]
       │
       ▼
[Open "My Trips" Tab] ───> [Select Saved Trip: Kyoto]
                                │
                                ▼
                       [Open Interactive Map]
                                │
                                ▼
                     [Search Offline POIs: Cafes]
                                │
                                ▼
                     [Bookmark Fushimi Inari]
```

1. **Offline Mode**: Omar opens OpenTrail while traveling through mountain areas without cellular reception.
2. **Trip Access**: Navigates to "My Trips" and opens the pre-cached "Kyoto Workcation" trip.
3. **Map Navigation**: Opens the interactive OpenStreetMap vector map viewer and searches cached points of interest for quiet cafes and landmarks.
4. **Bookmarking**: Taps the favorite button on "Fushimi Inari Shrine" to save it directly to his offline bookmarks list.

---

## Journey 3: Drag-and-Drop Itinerary & Smart Packing (Sarah — Family Planner)

```
[Open Trip Itinerary]
       │
       ▼
[Drag Activity to Reorder] ───> [Auto-Update Route Durations]
                                      │
                                      ▼
                           [Open Packing Checklist]
                                      │
                                      ▼
                        [Generate Weather Checklist]
                                      │
                                      ▼
                           [Check off Packed Items]
```

1. **Itinerary Adjustment**: Sarah opens her family trip to Japan and uses fluid drag-and-drop reordering to move the "Kyoto Imperial Palace" visit from afternoon to morning.
2. **Duration Calculation**: OpenTrail recalculates travel time estimates between activities automatically.
3. **Smart Packing**: Sarah switches to the "Packing List" tab and taps "Auto-Generate Packing List". OpenTrail generates checklist items (rainjackets, power adapters, walking shoes) tailored to Kyoto's rain forecast.
4. **Execution**: Checks off items as she packs her family's bags.

---

## Journey 4: RTL & Multilingual Theme Switcher (Arabic/Urdu Localized User)

```
[Open Settings Tab]
       │
       ▼
[Select Language: Arabic / Urdu] ───> [App Re-renders in Native RTL]
                                              │
                                              ▼
                                   [Toggle Dark Mode Theme]
                                              │
                                              ▼
                                   [Seamless UI Transition]
```

1. **Settings Navigation**: User opens the Settings tab and selects "Arabic" or "Urdu" as the application language.
2. **RTL Adaptation**: The entire application UI, navigation bar, drawer, and card layouts seamlessly mirror to right-to-left layout direction.
3. **Theme Customization**: User toggles from Light Mode to Dark Mode; design tokens automatically update with zero flicker or layout shift.
