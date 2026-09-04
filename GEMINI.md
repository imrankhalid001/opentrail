# GEMINI.md — Permanent Manual for AI Coding Agents 🤖🗺️

This document is the **authoritative rulebook and operating manual** for any AI coding agent (including Gemini, Claude, GPT, or sub-agents) working on the **OpenTrail** codebase.

---

## 🎯 Project Identity & Purpose

**OpenTrail** is an open-source, feature-rich, UI/UX-first travel intelligence application built with Flutter and Dart. It provides destination intelligence, weather forecasts, interactive maps, drag-and-drop itinerary planning, smart packing lists, and local analytics with a 100% offline-first architecture.

---

## 🛑 Strict Rules & Guardrails

### 1. No Premature Feature Implementation
- Do **NOT** invent unrequested features or implement screens outside the explicitly assigned scope/milestone.
- Do **NOT** add dummy CRUD screens or fake API implementations just to make the UI look filled out.

### 2. Architecture Compliance (Feature-First MVVM)
- **Hierarchy**: `View` ──> `ViewModel` ──> `Repository` ──> `Service` / `Local Database`.
- **Repositories are the Source of Truth**: UI components **never** query REST APIs or local databases directly.
- **Business Logic Placement**: Presentation logic belongs in ViewModels (`Notifier` / `StateNotifier`). Widgets must remain declarative and thin.
- **Result Monad**: Repositories **must** return `Result<T, Exception>` (`Success` or `Failure`). Never throw raw exceptions up to the UI layer.

### 3. Component Reusability First
- **Always Search First**: Before writing any new Flutter widget, search `lib/core/widgets/` to see if a reusable widget exists (`AppButton`, `AppCard`, `AppTextField`, `AppSearchBar`, `AppErrorState`, `AppEmptyState`, `AppLoading`, `AppSkeleton`, `AppChip`, `AppBadge`, `AppRating`, `AppFavoriteButton`).
- **Shared Code Rules**: Truly shared widgets belong in `lib/core/widgets/`. Feature-specific widgets must remain scoped inside `lib/features/<feature_name>/presentation/widgets/`.
- **No Dumping Grounds**: Do **not** create a generic `utils.dart` file. Keep utilities small, single-purpose, and typed (e.g., `date_formatter.dart`).

### 4. Zero Secrets & Free APIs Only
- **Never commit secrets**: No API keys, passwords, tokens, or credentials in code or `.env` files.
- **Use Public/Free APIs**: Core functionality must rely on free open data sources (Open-Meteo, OpenStreetMap, Wikipedia, RestCountries). Do **NOT** introduce paid API services as mandatory dependencies.

### 5. Dependency Governance
- Do **NOT** add third-party packages to `pubspec.yaml` without documenting the justification in `docs/engineering/dependencies.md`.
- Prefer official Flutter/Dart capabilities whenever sufficient.

---

## 🔄 Agent Execution Workflow

When assigned a task, every AI agent **must** follow this exact sequence:

1. **Read GEMINI.md**: Confirm understanding of non-negotiable rules.
2. **Inspect Context**: Search existing code using `find_files`, `find_declaration`, or `grep` to avoid duplicate implementations.
3. **Plan the Change**: Formulate a minimal, targeted implementation plan.
4. **Implement**:
   - Reuse existing design tokens (`AppColors`, `AppTypography`, `AppSpacing`).
   - Reuse existing widgets from `lib/core/widgets/`.
   - Implement localized strings in `lib/l10n/app_en.arb` (no hardcoded string literals in UI).
5. **Add/Update Tests**: Write corresponding unit or widget tests.
6. **Verify Code Quality**:
   - Run `dart format .`
   - Run `flutter analyze`
   - Run `flutter test`
7. **Report Progress**: Provide a clear, factual summary of files created, modified, and test results.

---

## 🚫 Forbidden Actions

- ❌ Writing code that violates `flutter analyze` or fails `flutter test`.
- ❌ Modifying unrelated files or refactoring working core architecture without explicit approval.
- ❌ Committing secrets, API keys, or `.env` credential files.
- ❌ Force pushing or performing destructive Git operations.
- ❌ Suppressing analyzer warnings using `// ignore:` comments without explicit architectural justification.
