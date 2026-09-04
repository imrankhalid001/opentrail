# Git Workflow & Branching Strategy 🌿

OpenTrail uses a structured feature-branch Git workflow and Conventional Commits.

---

## 1. Branch Hierarchy

- `main`: Production-ready stable branch.
- `feature/*`: Feature development branches (e.g., `feature/weather-forecast-card`).
- `fix/*`: Bug fix branches (e.g., `fix/itinerary-drag-drop-reorder`).
- `refactor/*`: Code refactoring branches.
- `docs/*`: Documentation updates.
- `chore/*`: Tooling or build configuration updates.

---

## 2. Conventional Commits Standard

Commits follow the Conventional Commits specification:
- `feat: add live weather 7-day forecast card`
- `fix: resolve dark theme text contrast on destination card`
- `refactor: extract date_formatter utility`
- `docs: update API strategy for Open-Meteo`
- `test: add widget tests for AppSearchBar`
- `chore: update Riverpod dependency version`

---

## 3. Pull Request Rules
- Branch protection on `main`. No force pushing.
- All PRs require `flutter analyze` and `flutter test` checks to pass.
