import 'package:flutter/foundation.dart';

/// The default tag used for logging messages.
const String BASE_TAG = 'WebEngageFlutter';

/// Utility class for logging messages at various levels to the console.
///
/// Provides methods to log messages at different levels: INFO, DEBUG, WARN, ERROR, and VERBOSE.
/// Log levels can be configured, and logs can be conditionally enabled for release builds.
class WELogger {
  /// Factory constructor to access the singleton instance of `WELogger`.
  factory WELogger() => _logger;

  /// Private constructor for singleton pattern.
  WELogger._();

  // Singleton instance of `WELogger`.
  static final WELogger _logger = WELogger._();

  /// Flag indicating if logs are enabled in release mode.
  ///
  /// By default, logs are only enabled in debug and profile modes.
  bool _isEnabledForReleaseBuild = false;

  /// Minimum log level for displaying logs.
  ///
  /// Logs below this level will not be displayed.
  LogLevel _logLevel = LogLevel.INFO;

  /// Configures the logging level and release mode logging behavior.
  ///
  /// - [logLevel]: Sets the minimum level of logs to display.
  /// - [isEnabledForReleaseBuild]: Enables logs in release mode if set to `true`.
  static void configureLogs(LogLevel logLevel,
      [bool isEnabledForReleaseBuild = false]) {
    _logger._logLevel = logLevel;
    _logger._isEnabledForReleaseBuild = isEnabledForReleaseBuild;
  }

  /// Logs an INFO level message.
  static void i(String message) => _log(message, logLevel: LogLevel.INFO);

  /// Logs a DEBUG level message.
  static void d(String message) => _log(message, logLevel: LogLevel.DEBUG);

  /// Logs a WARN level message, displayed in yellow.
  static void w(String message) =>
      _log(message, logLevel: LogLevel.WARN, textColor: '\x1B[33m');

  /// Logs an ERROR level message, displayed in red, with optional error and stack trace details.
  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(
      message,
      logLevel: LogLevel.ERROR,
      error: error,
      stackTrace: stackTrace,
      textColor: '\x1B[31m',
    );
  }

  /// Logs a VERBOSE level message.
  static void v(String message) => _log(message, logLevel: LogLevel.VERBOSE);

  /// Handles the core log logic based on log level, error, and optional color formatting.
  ///
  /// - [message]: The message to log.
  /// - [logLevel]: The severity level of the log message.
  /// - [error]: An optional error object to include in the log message.
  /// - [stackTrace]: An optional stack trace for error logs.
  /// - [textColor]: An optional text color to apply to the log message.
  static void _log(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    required LogLevel logLevel,
    String? textColor,
  }) {
    // Return early if the log level does not meet the threshold.
    if (_logger._logLevel.index < logLevel.index) return;

    // Log in debug, profile, or release mode (if enabled for release).
    if (kDebugMode || kProfileMode || _logger._isEnabledForReleaseBuild) {
      final methodName = _getMethodName();
      final logMessage = _buildMessage(
          message, methodName, logLevel, stackTrace, error, textColor);
      debugPrint(logMessage);
    }
  }

  /// Helper method to get the name of the calling method using the stack trace.
  ///
  /// This extracts the method name from the current call stack, which is useful for debugging and tracking log origins.
  static String _getMethodName() {
    return "";
  }

  /// Constructs the formatted log message with optional error and stack trace information.
  ///
  /// - [message]: The main log message.
  /// - [methodName]: The name of the calling method.
  /// - [logLevel]: The log level associated with this message.
  /// - [stackTrace]: An optional stack trace to append.
  /// - [error]: An optional error object to append.
  /// - [textColor]: Optional color code for the message.
  static String _buildMessage(
    String message,
    String methodName,
    LogLevel logLevel,
    StackTrace? stackTrace,
    dynamic error,
    String? textColor,
  ) {
    final buffer = StringBuffer()
      ..write(textColor ?? '')
      ..write('${DateTime.now()} ')
      ..write('$BASE_TAG $message');

    if (error != null) buffer.write(' | Error: $error');
    if (stackTrace != null) buffer.write(' | StackTrace: $stackTrace');

    // Reset color formatting
    if (textColor != null) buffer.write('\x1B[0m');

    return buffer.toString();
  }
}

/// Enum representing log levels to control logging verbosity.
///
/// The log levels are ordered by severity, with `NO_LOG` being the lowest (no logging)
/// and `VERBOSE` being the highest (detailed logging).
enum LogLevel {
  /// No logs will be shown.
  NO_LOG,

  /// Only error logs will be shown.
  ERROR,

  /// Warning logs and above will be shown.
  WARN,

  /// Info logs and above will be shown.
  INFO,

  /// Debug logs and above will be shown.
  DEBUG,

  /// All logs, including verbose logs, will be shown.
  VERBOSE,
}
