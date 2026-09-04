# Animations & Motion Strategy 🎬

Motion in OpenTrail is functional, fluid, and purposeful — providing physical affordance during navigation and state transitions.

## Motion Standards
- **Short Micro-Interactions**: `150ms–200ms` for button presses, icon toggles (`AppFavoriteButton`), and checkbox animations using `Curves.easeOutCubic`.
- **Medium Transitions**: `300ms–400ms` for bottom sheet expansion, dialog presentation, and tab switching using `Curves.fastOutSlowIn`.
- **Page Transitions**: `350ms` shared axis or fade-through transitions powered by GoRouter.

---

## Accessibility & Reduced Motion
OpenTrail respects system motion preferences:
```dart
final reduceMotion = MediaQuery.of(context).disableAnimations;
```
When `disableAnimations` is enabled, transition durations collapse to 0ms.
