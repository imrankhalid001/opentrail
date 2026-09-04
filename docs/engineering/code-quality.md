# Code Quality, Formatting & Static Analysis Guidelines 🧹

OpenTrail enforces high code quality standards to ensure consistency, readability, and null safety.

---

## 1. Quality Gates
Before submitting any pull request or committing code, all changes must pass three mandatory quality gates:

```bash
# 1. Format code according to Dart guidelines
dart format .

# 2. Run static analysis (0 warnings / errors required)
flutter analyze

# 3. Execute unit and widget tests
flutter test
```

---

## 2. Static Analysis Configuration (`analysis_options.yaml`)
- `strict-casts: true`
- `strict-inference: true`
- `strict-raw-types: true`
- Enforces `prefer_const_constructors`, `prefer_single_quotes`, and `use_build_context_synchronously`.

---

## 3. Code Standards & Rules
- **No Unused Imports / Code**: Unused variables, dead imports, or commented-out code blocks are strictly forbidden.
- **No Suppressing Warnings**: Suppressing analyzer warnings using `// ignore:` comments without explicit architectural justification is forbidden.
- **Logging Policy**: Use `AppLogger.d()` or `AppLogger.e()` instead of `print()` or `debugPrint()`.
- **TODO Policy**: All TODO comments must include an issue reference (e.g., `// TODO(#42): Refactor tile caching engine`).
