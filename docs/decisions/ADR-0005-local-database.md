# ADR-0005: Drift SQLite Engine for Offline Data Caching

## Context
OpenTrail requires a high-performance local database for storing offline maps, cached destination metadata, user trip itineraries, and packing checklists.

## Decision
Adopt **Drift** (SQLite for Flutter) as the local relational database engine.

## Alternatives Considered
1. *Hive*: Key-value NoSQL store lacking complex relational query capabilities for itinerary items and foreign keys.
2. *Isar*: Unclear future maintenance status.
3. *sqflite*: Raw SQL string queries without compile-time query verification or reactive streams.

## Consequences
- Type-safe compile-time SQL queries.
- Native reactive `Stream` query support for real-time UI updates.
