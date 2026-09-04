import 'package:flutter/foundation.dart';

/// Sealed exception hierarchy for OpenTrail.
@immutable
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic cause;

  const AppException({required this.message, this.code, this.cause});

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network communication failures (timeouts, bad status code, no internet).
final class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException({
    required super.message,
    super.code,
    super.cause,
    this.statusCode,
  });
}

/// Database read/write or transaction errors.
final class DatabaseException extends AppException {
  const DatabaseException({required super.message, super.code, super.cause});
}

/// Data parsing or JSON serialization errors.
final class ParseException extends AppException {
  const ParseException({required super.message, super.code, super.cause});
}

/// Location or GPS permission errors.
final class LocationException extends AppException {
  const LocationException({required super.message, super.code, super.cause});
}

/// Generic fallback exception.
final class UnknownException extends AppException {
  const UnknownException({required super.message, super.code, super.cause});
}
