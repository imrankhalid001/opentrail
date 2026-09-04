# Code Quality Standards & Lints 🛠️

OpenTrail enforces strict static analysis standards to guarantee readable, maintainable Dart code.

## Quality Gates
1. **Formatting**: `dart format .` must produce zero changes.
2. **Static Analysis**: `flutter analyze` must pass with **0 warnings and 0 errors**.
3. **Automated Lints**: `analysis_options.yaml` enables `strict-casts`, `strict-inference`, and `strict-raw-types`.

---

## Code Style Rules
- Always use `const` constructors where applicable.
- Name files using `snake_case.dart`.
- Name classes using `PascalCase`.
- Name variables, functions, and parameters using `camelCase`.
- Mark private members with an underscore `_`.
