# Essential Development Commands 💻

Common CLI development commands for building, testing, and verifying OpenTrail:

```bash
# 1. Fetch pub dependencies
flutter pub get

# 2. Run code generation (Freezed, JSON Serializable, Drift)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Format code
dart format .

# 4. Static analysis
flutter analyze

# 5. Execute all unit and widget tests
flutter test

# 6. Run application in development mode
flutter run

# 7. Build release APK
flutter build apk --release
```
