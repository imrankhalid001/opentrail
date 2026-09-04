# Testing Strategy 🧪

OpenTrail maintains high quality through a multi-tiered automated testing hierarchy.

```
       / \
      / E2E \       <- Critical User Journeys (Integration Test)
     /-------\
    / Widget  \     <- Reusable UI Components & Screen States
   /-----------\
  /    Unit     \   <- ViewModels, Repositories, Utilities
 /---------------\
```

## Coverage Principles
- **Unit Tests**: Focus on ViewModels, Repositories, Result transformations, and formatters/utilities.
- **Widget Tests**: Focus on reusable components in `lib/core/widgets/` and state branch rendering (`loading`, `error`, `data`).
- **Integration Tests**: Verify end-to-end trip creation and offline caching flows.
