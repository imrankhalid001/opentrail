# CLI Development Commands Guide 🛠️

This document lists essential CLI commands for developing, testing, and formatting OpenTrail.

---

## 1. Setup & Package Management

```bash
# Fetch all dependencies
flutter pub get

# Upgrade dependencies (compatible versions)
flutter pub upgrade
```

---

## 2. Code Generation (`build_runner`)

```bash
# Run one-time code generation for Freezed & Drift models
dart run build_runner build --delete-conflicting-outputs

# Watch for file changes during active development
dart run build_runner watch --delete-conflicting-outputs
```

---

## 3. Formatting, Analysis & Testing

```bash
# 1. Format code according to Dart guidelines
dart format .

# 2. Run static analysis (must report zero issues)
flutter analyze

# 3. Run all unit and widget tests
flutter test

# 4. Run tests with coverage output
flutter test --coverage
```

---

## 4. Running the Application

```bash
# Run on default connected device/emulator
flutter run

# Run on specific target platform
flutter run -d macos
flutter run -d chrome
```
