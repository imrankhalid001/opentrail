# Integration Testing Guidelines 🚀

Integration tests verify end-to-end workflows across navigation routes, repository data fetching, and local SQLite database persistence.

## Key Integration Test Scenarios
1. **Offline Mode Recovery**: Saving a trip while online, disconnecting network connectivity, relaunching app, and verifying trip data remains accessible.
2. **Search to Itinerary Flow**: Searching for "Tokyo", opening destination details, adding to trip itinerary, and verifying SQLite insertion.
