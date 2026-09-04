# Performance Optimization Standards ⚡

To maintain fluid 60 FPS / 120 FPS rendering across devices, OpenTrail adheres to strict performance rules:

1. **Const Constructors**: Use `const` for all immutable widget instantiations to prevent redundant element re-renders.
2. **Repaint Boundaries**: Wrap heavy animation widgets and custom painters in `RepaintBoundary`.
3. **Image Caching & Resizing**: Use `cached_network_image` with explicit `memCacheWidth` / `memCacheHeight` parameters to prevent GPU texture memory bloat.
4. **Lazy List Loading**: Use `ListView.builder` and `CustomScrollView` with slivers for large feeds.
