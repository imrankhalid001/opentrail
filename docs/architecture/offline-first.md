# Offline-First Architecture & Sync Engine 📶

OpenTrail is built with a **100% Offline-First Core**. All application features — browsing saved destinations, inspecting trip itineraries, checking packing lists, viewing offline maps, and reading saved travel guides — operate seamlessly without an active internet connection.

---

## 1. Stale-While-Revalidate Data Flow Pipeline

Data flows through a structured offline-first synchronization pipeline:

```
                  [UI Layer Request]
                          │
                          ▼
             [ViewModel / Riverpod Notifier]
                          │
                          ▼
            [Repository (Single Source of Truth)]
                          │
       ┌──────────────────┴──────────────────┐
       ▼                                     ▼
 [1. Read Local SQLite DB]         [2. Check Network Connection]
 (Instant emit to UI)                        │
                                  ┌──────────┴──────────┐
                                  ▼                     ▼
                             [Online]               [Offline]
                                  │                     │
                     [Fetch Remote Dio REST]      [Emit Offline State]
                                  │               (Display Cached Data
                     [Update Local SQLite]         + "Offline Mode" chip)
                                  │
                       [Emit Updated Data to UI]
```

---

## 2. Offline Fallback & Degradation Behavior

### Read Operations
- **Cached Data Available**: The UI instantly renders cached SQLite data. If the user is offline, an subtle "Offline Mode — Displaying Cached Data" chip is presented in the screen app bar.
- **No Cached Data & Offline**: The UI renders an `AppErrorState` or `AppEmptyState` explaining that network connectivity is required to perform the initial download for the requested destination or weather forecast, providing a "Retry Connection" action button.

### Write Operations (Offline Mutations)
- When a user performs an offline action (e.g., adding an itinerary activity, toggling a packing checklist item, or bookmarking a destination):
  1. The change is **written immediately to local SQLite** so the UI reflects instant feedback.
  2. The operation is queued in an offline sync queue table inside SQLite (`sync_queue`).
  3. When network connectivity is restored, the repository processes queued sync events in background mode.
