import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Centralized logger for OpenTrail.
class AppLogger {
  AppLogger._();

  static void debug(String message, {String tag = 'OpenTrail'}) {
    if (kDebugMode) {
      developer.log('🔵 [DEBUG] $message', name: tag);
    }
  }

  static void info(String message, {String tag = 'OpenTrail'}) {
    developer.log('🟢 [INFO] $message', name: tag);
  }

  static void warning(String message, {String tag = 'OpenTrail'}) {
    developer.log('🟡 [WARN] $message', name: tag);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = 'OpenTrail',
  }) {
    developer.log(
      '🔴 [ERROR] $message',
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
