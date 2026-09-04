import 'package:flutter/foundation.dart';

/// Sealed Result monad for explicit error handling across OpenTrail repositories.
@immutable
sealed class Result<S, E extends Exception> {
  const Result();

  /// Executes [onSuccess] if this is [Success], or [onFailure] if this is [Failure].
  R fold<R>({
    required R Function(S value) onSuccess,
    required R Function(E exception) onFailure,
  }) {
    return switch (this) {
      Success<S, E>(:final value) => onSuccess(value),
      Failure<S, E>(:final exception) => onFailure(exception),
    };
  }

  /// Returns `true` if this is [Success].
  bool get isSuccess => this is Success<S, E>;

  /// Returns `true` if this is [Failure].
  bool get isFailure => this is Failure<S, E>;

  /// Gets the value if [Success], or `null` if [Failure].
  S? get valueOrNull => switch (this) {
    Success<S, E>(:final value) => value,
    Failure<S, E>() => null,
  };

  /// Gets the exception if [Failure], or `null` if [Success].
  E? get exceptionOrNull => switch (this) {
    Success<S, E>() => null,
    Failure<S, E>(:final exception) => exception,
  };
}

/// Represents a successful computation returning [value].
final class Success<S, E extends Exception> extends Result<S, E> {
  final S value;

  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<S, E> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Result.success($value)';
}

/// Represents a failed computation encapsulation [exception].
final class Failure<S, E extends Exception> extends Result<S, E> {
  final E exception;

  const Failure(this.exception);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<S, E> &&
          runtimeType == other.runtimeType &&
          exception == other.exception;

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'Result.failure($exception)';
}
