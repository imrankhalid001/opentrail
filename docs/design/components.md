# Design System Component Catalog 🧩

This catalog provides detailed specifications for all reusable UI components in OpenTrail (`lib/core/widgets/`). Every component is designed to be composable, configurable, Material 3 aligned, fully accessible (WCAG AA), and responsive across light/dark themes and RTL localizations.

---

## 1. Base Buttons & Interactive Controls

### `AppButton`
- **Description**: Standard elevated, filled, outline, or tonal action button with integrated loading state.
- **Key Parameters**: `label: String`, `onPressed: VoidCallback?`, `variant: AppButtonVariant`, `isLoading: bool`, `icon: IconData?`
- **Accessibility**: Minimum 48x48 dp touch target; screen reader semantics (`Semantics(button: true)`).

### `AppTextButton`
- **Description**: Text-only button for secondary or tertiary inline actions.
- **Key Parameters**: `label: String`, `onPressed: VoidCallback?`, `textColor: Color?`

### `AppIconButton`
- **Description**: Icon button with circular ink ripple and optional badge count overlay.
- **Key Parameters**: `icon: IconData`, `onPressed: VoidCallback?`, `tooltip: String`, `badgeCount: int?`

### `AppFavoriteButton`
- **Description**: Heart icon toggle button with smooth scale transition animation for quick bookmarking.
- **Key Parameters**: `isFavorite: bool`, `onToggle: ValueChanged<bool>`, `size: double = 24.0`

### `AppRating`
- **Description**: Read-only or interactive star rating display with support for half-star values.
- **Key Parameters**: `rating: double`, `maxRating: int = 5`, `onRatingChanged: ValueChanged<double>?`

---

## 2. Input Fields & Search

### `AppTextField`
- **Description**: Standardized Material 3 text field with validation error state, prefix/suffix icons, and helper text.
- **Key Parameters**: `controller: TextEditingController?`, `label: String?`, `hint: String?`, `errorText: String?`, `obscureText: bool`

### `AppSearchBar`
- **Description**: Specialized search bar with integrated clear button, debounced query callbacks, and filter trigger.
- **Key Parameters**: `hint: String`, `onChanged: ValueChanged<String>`, `onClear: VoidCallback?`, `onFilterTap: VoidCallback?`

---

## 3. Surface Cards & Content Tiles

### `AppCard`
- **Description**: Core Material 3 surface card wrapper with customizable elevation, border, padding, and tap feedback.
- **Key Parameters**: `child: Widget`, `onTap: VoidCallback?`, `padding: EdgeInsetsGeometry?`, `variant: AppCardVariant`

### `AppSectionHeader`
- **Description**: Standardized section header with title, subtitle, and optional "View All" action button.
- **Key Parameters**: `title: String`, `subtitle: String?`, `actionLabel: String?`, `onActionPressed: VoidCallback?`

### `AppListTile`
- **Description**: Standardized list item with leading icon/avatar, title, subtitle, trailing widget, and tap action.
- **Key Parameters**: `title: String`, `subtitle: String?`, `leading: Widget?`, `trailing: Widget?`, `onTap: VoidCallback?`

### `AppDestinationCard`
- **Description**: Card component for displaying destination photos, country title, region, and favorite toggle.
- **Key Parameters**: `imageUrl: String`, `title: String`, `country: String`, `isFavorite: bool`, `onTap: VoidCallback`

### `AppWeatherCard`
- **Description**: Specialized card for weather forecasts showing current temperature, weather condition icon, humidity, and precipitation.
- **Key Parameters**: `temperature: double`, `condition: String`, `icon: IconData`, `highTemp: double`, `lowTemp: double`

### `AppPlaceCard`
- **Description**: Point of interest card displaying attraction title, category chip, distance, and rating.
- **Key Parameters**: `title: String`, `category: String`, `imageUrl: String?`, `rating: double`, `distanceKm: double?`

### `AppTripCard`
- **Description**: Trip overview card showing trip dates, cover photo, countdown badge, and progress bar.
- **Key Parameters**: `tripTitle: String`, `destination: String`, `startDate: DateTime`, `endDate: DateTime`, `progress: double`

### `AppStatCard`
- **Description**: Compact statistical card displaying numerical metrics (e.g. "Visited Countries: 12") with trend icon.
- **Key Parameters**: `label: String`, `value: String`, `icon: IconData`, `color: Color?`

---

## 4. Chips, Badges & Tags

### `AppChip`
- **Description**: Interactive filter or choice chip with selected state visual feedback.
- **Key Parameters**: `label: String`, `isSelected: bool`, `onSelected: ValueChanged<bool>`, `icon: IconData?`

### `AppBadge`
- **Description**: Compact status indicator pill or counter badge.
- **Key Parameters**: `label: String`, `backgroundColor: Color?`, `textColor: Color?`

### `AppTag`
- **Description**: Small non-interactive metadata tag for categorizing items (e.g., "Historical", "Free Entry").
- **Key Parameters**: `label: String`, `icon: IconData?`

---

## 5. Feedback, Progress & Empty States

### `AppLoading`
- **Description**: Centralized loading indicator with optional progress message or full-screen transparent modal overlay.
- **Key Parameters**: `message: String?`, `isOverlay: bool = false`

### `AppSkeleton`
- **Description**: Shimmer loading placeholder for smooth layout loading feedback.
- **Key Parameters**: `width: double`, `height: double`, `borderRadius: BorderRadius?`

### `AppErrorState`
- **Description**: Standardized error display with error graphic, message, and retry button.
- **Key Parameters**: `title: String?`, `message: String`, `onRetry: VoidCallback?`, `icon: IconData?`

### `AppEmptyState`
- **Description**: Empty list or no-data placeholder with illustrative icon, title, subtitle, and primary action.
- **Key Parameters**: `title: String`, `subtitle: String?`, `actionLabel: String?`, `onActionPressed: VoidCallback?`

### `AppSnackbar`
- **Description**: Standardized floating snackbar notification utility for success, info, and error toasts.
- **Key Parameters**: `message: String`, `type: AppSnackbarType`, `actionLabel: String?`, `onAction: VoidCallback?`

---

## 6. Overlays & Dialogs

### `AppBottomSheet`
- **Description**: Drag-handle enabled modal bottom sheet container for filter menus and quick actions.
- **Key Parameters**: `title: String?`, `child: Widget`, `isDismissible: bool = true`

### `AppDialog`
- **Description**: Standardized Material 3 alert dialog with title, body, primary action, and cancel option.
- **Key Parameters**: `title: String`, `content: Widget`, `confirmLabel: String`, `onConfirm: VoidCallback`

---

## 7. Media, Avatars & Dividers

### `AppAvatar`
- **Description**: Circular user avatar or profile picture with fallback initials.
- **Key Parameters**: `imageUrl: String?`, `initials: String?`, `radius: double = 20.0`

### `AppImage` & `AppNetworkImage`
- **Description**: Cached network image loader with skeleton shimmer fallback, error handling, and hero animation support.
- **Key Parameters**: `imageUrl: String`, `width: double?`, `height: double?`, `fit: BoxFit = BoxFit.cover`

### `AppDivider`
- **Description**: Material 3 horizontal or vertical separator line with customizable indent and color.
- **Key Parameters**: `height: double = 1.0`, `indent: double = 0.0`, `endIndent: double = 0.0`

---

## 8. Motion Wrappers & Transitions

### `AppAnimatedSwitcher`
- **Description**: Smooth cross-fade or scale transition container for switching between child widgets (e.g., loading state to content).
- **Key Parameters**: `child: Widget`, `duration: Duration = const Duration(milliseconds: 300)`

### `AppPageTransition`
- **Description**: Shared axis or fade-through page transition builder for GoRouter route navigation.
- **Key Parameters**: `child: Widget`, `animation: Animation<double>`
