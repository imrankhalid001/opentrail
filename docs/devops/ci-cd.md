# Continuous Integration & Continuous Deployment (CI/CD) ⚙️

OpenTrail uses GitHub Actions for automated non-destructive code validation.

```
 [Pull Request / Push to Main]
              │
              ▼
    [1. Set up Flutter SDK]
              │
              ▼
   [2. Run flutter pub get]
              │
              ▼
   [3. Check Code Formatting]
       (dart format)
              │
              ▼
   [4. Execute Static Analysis]
      (flutter analyze)
              │
              ▼
   [5. Run Automated Test Suite]
       (flutter test)
```

No automated publishing to app stores occurs without human release tagging and manual approval.
