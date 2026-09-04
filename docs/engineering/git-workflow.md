# Git Workflow & Branch Strategy 🌿

OpenTrail follows a structured feature-branch workflow.

## Branch Hierarchy
```text
main (stable release-ready code)
  ├── feature/explore-feed
  ├── fix/weather-card-overflow
  ├── docs/update-architecture
  └── refactor/extract-app-card
```

---

## Branch Rules
1. `main` is protected — direct commits to `main` are prohibited.
2. All changes must be submitted via Pull Requests.
3. PRs require passing CI validation (`dart format`, `flutter analyze`, `flutter test`).
4. Commit messages follow Conventional Commits format (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`).
