import 'package:flutter/foundation.dart';

/// Base Tag for Logger
const String BASE_TAG = 'WebEngageFlutter';

/// Logger Util Class to print logs to the Flutter Console
class Logger {
  /// Factory Constructor
  factory Logger() => _logger;

  Logger._();
  static final Logger _logger = Logger._();

  /// Flag to handle logs in Release build. By default, logs in release mode will be disabled.
  bool _isEnabledForReleaseBuild = false;

  /// LogLevel for SDK logs.
  LogLevel _logLevel = LogLevel.INFO;

  /// Configure the logger settings.
  /// [logLevel] - Control log levels.
  /// [isEnabledForReleaseBuild] - If true, logs will be enabled in release builds.
  static void configureLogs(LogLevel logLevel,
      [bool isEnabledForReleaseBuild = false]) {
    _logger._logLevel = logLevel;
    _logger._isEnabledForReleaseBuild = isEnabledForReleaseBuild;
  }

  /// Log an INFO level message.
  static void i(String message) => _log(message, logLevel: LogLevel.INFO);

  /// Log a DEBUG level message.
  static void d(String message) => _log(message, logLevel: LogLevel.DEBUG);

  /// Log a WARN level message.
  static void w(String message) =>
      _log(message, logLevel: LogLevel.WARN, textColor: '\x1B[33m');

  /// Log an ERROR level message with optional error and stack trace.
  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(message,
        logLevel: LogLevel.ERROR,
        error: error,
        stackTrace: stackTrace,
        textColor: '\x1B[31m');
  }

  /// Log a VERBOSE level message.
  static void v(String message) => _log(message, logLevel: LogLevel.VERBOSE);

  /// Core log method to handle different log levels and build log messages.
  static void _log(String message,
      {dynamic error,
      StackTrace? stackTrace,
      required LogLevel logLevel,
      String? textColor}) {
    // Return early if log level is below the configured threshold.
    if (_logger._logLevel.index < logLevel.index) return;

    // Only log in debug, profile, or release (if enabled) modes.
    if (kDebugMode || kProfileMode || _logger._isEnabledForReleaseBuild) {
      final logMessage =
          _buildMessage(message, logLevel, stackTrace, error, textColor);
      debugPrint(logMessage);
    }
  }

  /// Helper method to construct the log message.
  static String _buildMessage(String message, LogLevel logLevel,
      StackTrace? stackTrace, dynamic error, String? textColor) {
    final buffer = StringBuffer()
      ..write(textColor ?? '')
      ..write('${DateTime.now()} ')
      ..write('$BASE_TAG $message');

    if (error != null) buffer.write(' Error: $error');
    if (stackTrace != null) buffer.write(' StackTrace: $stackTrace');

    // Reset text color if applied
    if (textColor != null) buffer.write('\x1B[0m');

    return buffer.toString();
  }
}

/// LogLevel to define the severity of log messages.
enum LogLevel {
  NO_LOG, // No logs.
  ERROR, // Only error logs.
  WARN, // Warning logs.
  INFO, // Info logs.
  DEBUG, // Debug logs.
  VERBOSE // Verbose logs.
}
