# Unit Testing Guidelines 🧪

Unit tests in OpenTrail target ViewModels, Repositories, Services, Result monads, and utility formatters.

## Guidelines
1. Tests use `flutter_test` and `ProviderContainer`.
2. Repositories and REST clients are mocked using `ProviderContainer(overrides: [...])`.
3. Test success and failure branches for `Result<S, E>`.
