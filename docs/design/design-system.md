# Design System Specification 📐

## Overview
The OpenTrail Design System is built upon **Material Design 3 (M3)** with custom design tokens specifically tailored for travel intelligence interfaces (maps, weather cards, itinerary timelines, and media cards).

---

## Design System Tokens
All design system tokens are centralized inside `lib/app/theme/`:
- `AppColors`: Color tokens for Light and Dark modes.
- `AppTypography`: TextStyles following M3 scale (Display, Headline, Title, Body, Label).
- `AppSpacing`: 8pt grid metrics (`xs: 4`, `sm: 8`, `md: 16`, `lg: 24`, `xl: 32`, `xxl: 48`).
- `AppRadii`: Corner radii (`sm: 8.dp`, `md: 12.dp`, `lg: 16.dp`, `xl: 24.dp`, `full: 999.dp`).

---

## System Rules
1. **Zero Hardcoded Values**: Never write `Color(0xFF...)` or `EdgeInsets.all(16)` directly in feature widgets. Use `AppColors`, `AppSpacing`, or `Theme.of(context)`.
2. **Component Reusability**: If a UI pattern appears more than once, it must be extracted into `lib/core/widgets/`.
3. **Adaptive Contrast**: Ensure text contrast meets WCAG AA standards (4.5:1 ratio for body text) across both Light and Dark themes.
