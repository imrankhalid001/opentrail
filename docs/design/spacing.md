# Spacing, Padding & Grid 📐

OpenTrail uses an **8pt Grid System** for predictable, clean layouts across all screen form factors.

## Spacing Constants (`AppSpacing`)

```dart
class AppSpacing {
  static const double xxs = 2.0;
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0; // Standard screen padding
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}
```

---

## Layout Rules
- **Screen Edge Margin**: `16.0 dp` on mobile, `24.0 dp` on tablet/desktop.
- **Card Padding**: `16.0 dp` internal padding.
- **Gaps Between Cards**: `12.0 dp` vertically in lists.
- **Touch Target Size**: Minimum `48.0 x 48.0 dp` touch target for all interactive elements.
