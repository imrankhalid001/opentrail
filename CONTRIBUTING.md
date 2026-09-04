# Contributing to OpenTrail 🗺️

Thank you for your interest in contributing to **OpenTrail**! As an open-source, feature-rich travel intelligence app, we aim to maintain high code quality, beautiful UI craftsmanship, and robust architectural integrity.

---

## 📜 Code of Conduct

All contributors are expected to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it to understand expected interactions within our community.

---

## 🛠️ Development Workflow

1. **Fork & Clone the Repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/opentrail.git
   cd opentrail
   ```

2. **Create a Feature Branch**
   Follow our branch naming conventions:
   - `feature/description` for new features
   - `fix/description` for bug fixes
   - `docs/description` for documentation improvements
   - `refactor/description` for code refactoring
   - `chore/description` for maintenance or tool setup

3. **Follow Architectural Standards**
   - Use Feature-First MVVM + Repository pattern.
   - **Reuse components**: Search `lib/core/widgets/` before building custom UI controls.
   - Never place business logic directly inside Flutter widgets.
   - Use immutable data models and sealed `Result<T, Exception>` types for async repository returns.
   - Never hardcode user-facing strings; add them to `lib/l10n/app_en.arb`.

4. **Code Quality Gates**
   Before submitting a Pull Request, ensure all quality checks pass locally:
   ```bash
   # 1. Format code
   dart format .

   # 2. Static analysis
   flutter analyze

   # 3. Unit and Widget tests
   flutter test
   ```

---

## 📝 Commit Message Guidelines

We follow Conventional Commits format:

```text
<type>(<scope>): <short summary>

[optional body]
```

### Allowed Types
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Formatting, missing semi-colons, etc. (no code logic changes)
- `refactor`: Refactoring production code
- `test`: Adding missing tests or correcting existing tests
- `chore`: Maintenance tasks or build configurations

Examples:
- `feat(weather): add 7-day temperature trend chart component`
- `fix(navigation): fix deep link argument parsing for destination screen`
- `docs(architecture): add offline caching sequence diagram`

---

## 📥 Pull Request Checklist

When opening a Pull Request:
- [ ] Provide a clear, descriptive title and summary of changes.
- [ ] Reference related issues (e.g., `Fixes #42`).
- [ ] Ensure `flutter analyze` passes with zero warnings/errors.
- [ ] Add unit or widget tests covering new functionality or bug fixes.
- [ ] Update documentation files in `docs/` if architectural or design decisions were made.
- [ ] Ensure no secrets, tokens, or API keys are committed.
