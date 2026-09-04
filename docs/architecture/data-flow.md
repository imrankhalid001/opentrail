# Unidirectional Data Flow 🔄

In OpenTrail, data flows unidirectionally through explicit state transitions.

```
 [User Action (Tap Button)]
             │
             ▼
 [ViewModel Method Call]
             │
             ▼
 [Emit Loading State: AsyncValue.loading()]
             │
             ▼
 [Repository Fetch Data]
             ├───> Checks Local SQLite Cache
             └───> Fetches REST API (if stale)
             │
             ▼
 [Returns Result<T, Exception>]
             │
       ┌─────┴─────┐
       ▼           ▼
  [Success(data)] [Failure(exception)]
       │           │
       ▼           ▼
 [Emit Data]    [Emit Error State]
       │           │
       └─────┬─────┘
             ▼
 [UI Rebuilds via ref.watch()]
```

This pattern eliminates race conditions, guarantees reproducible UI states, and simplifies automated widget testing.
