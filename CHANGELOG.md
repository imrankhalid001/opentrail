# Changelog

All notable changes to the OpenTrail project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0-foundation] - 2026-09-03

### Added
- **Project Engineering Foundation**: Established feature-first folder structure, Riverpod state management rules, and GoRouter navigation shell.
- **Design System Foundation**: Created Material 3 theme tokens (`AppColors`, `AppTypography`, `AppSpacing`) and reusable widget library (`AppButton`, `AppCard`, `AppTextField`, `AppSearchBar`, `AppErrorState`, `AppEmptyState`, `AppLoading`, `AppSkeleton`, `AppChip`, `AppBadge`, `AppRating`, `AppFavoriteButton`).
- **Core Architecture & Utilities**: Sealed `Result<T, Exception>` monad, typed `AppException` hierarchy, and `AppLogger`.
- **Localization Infrastructure**: Added `.arb` catalog files for English, Urdu, Arabic (RTL), and Japanese.
- **Comprehensive Documentation**: Complete `docs/` suite covering PRD, Product Vision, Design System, Architecture, API Strategy, Engineering Standards, Testing Strategy, DevOps CI/CD, and Architecture Decision Records (`ADR-0001` through `ADR-0008`).
- **AI Agent Instructions**: Created `GEMINI.md` master manual for AI coding agents.
- **Open-Source Repository Files**: Added `README.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `LICENSE`, `.gitignore`, `.gitattributes`, `.env.example`, and `.github/` workflows.
