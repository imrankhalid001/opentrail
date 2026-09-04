# Accessibility Standards (a11y) ♿

OpenTrail is engineered to be fully accessible to users with visual, motor, or cognitive impairments in accordance with **WCAG 2.1 AA** standards.

## Core Accessibility Features

1. **Semantic Labels**: Every interactive control (`AppButton`, `AppFavoriteButton`, `AppSearchBar`) includes clear `Semantics(label: ..., hint: ...)` descriptions.
2. **Touch Target Size**: All interactive buttons enforce a minimum touch target boundary of `48 x 48 dp`.
3. **Contrast Ratios**: All text and icons maintain a minimum contrast ratio of 4.5:1 against their background surfaces in both Light and Dark themes.
4. **Dynamic Text Scaling**: Text scales gracefully up to 200% (`MediaQuery.textScaler`) without overflowing or clipping container bounds.
5. **RTL Support**: Full Right-to-Left layout support for Arabic and Urdu locales using Flutter's native directional widgets (`Directionality`, `EdgeInsetsDirectional`).
