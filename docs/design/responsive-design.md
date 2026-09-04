# Responsive & Adaptive Design 📱💻

OpenTrail scales seamlessly across phones, foldable devices, tablets, and desktop displays.

## Breakpoint Specification

```dart
class AppBreakpoints {
  static const double compactMax = 600.0;  // Mobile phones
  static const double mediumMax  = 840.0;  // Tablets & Foldables
  static const double expandedMax = 1200.0; // Desktop / Web
}
```

---

## Adaptive Layout Strategies
- **Compact (<600dp)**: Single-column scrollable feed, bottom navigation bar.
- **Medium (600–840dp)**: Two-column grid layout, navigation rail.
- **Expanded (>840dp)**: Multi-pane side-by-side view (e.g., Destination list on left, detail view on right).
