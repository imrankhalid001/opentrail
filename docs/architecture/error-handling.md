# Error Handling Strategy ⚠️

OpenTrail enforces a zero-uncaught-exception policy across all architectural layers using a strongly-typed **Result Monad** and a unified **Exception Hierarchy**.

---

## 1. Result Monad (`lib/core/result/result.dart`)

Repositories return `Result<S, E extends Exception>` instead of throwing unhandled exceptions:

```dart
sealed class Result<S, E extends Exception> {
  const Result();

  bool get isSuccess => this is Success<S, E>;
  bool get isFailure => this is Failure<S, E>;

  R fold<R>({
    required R Function(S data) onSuccess,
    required R Function(E exception) onFailure,
  }) {
    return switch (this) {
      Success(value: final data) => onSuccess(data),
      Failure(exception: final err) => onFailure(err),
    };
  }
}

final class Success<S, E extends Exception> extends Result<S, E> {
  final S value;
  const Success(this.value);
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  final E exception;
  const Failure(this.exception);
}
```

---

## 2. Typed Exception Hierarchy (`lib/core/errors/app_exception.dart`)

All exceptions inherit from `AppException`:

```dart
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final Object? cause;

  const AppException(this.message, {this.code, this.cause});
}

class NetworkException extends AppException {
  final int? statusCode;
  const NetworkException(super.message, {this.statusCode, super.code, super.cause});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.cause});
}

class ParseException extends AppException {
  const ParseException(super.message, {super.code, super.cause});
}

class LocationException extends AppException {
  const LocationException(super.message, {super.code, super.cause});
}

class UnknownException extends AppException {
  const UnknownException(super.message, {super.code, super.cause});
}
```

---

## 3. Presentation Layer Handling Rules

1. **No Stack Traces in UI**: Raw exception details and stack traces must never be exposed to end users.
2. **Localized Error Strings**: Exception types map to user-friendly localized messages using `AppLocalizations`.
3. **Inline Recovery vs Toast**:
   - Page load failures render an `AppErrorState` widget with a retry button (`onRetry`).
   - Action failures (e.g., bookmark toggle error) trigger a transient `AppSnackbar` toast message.
