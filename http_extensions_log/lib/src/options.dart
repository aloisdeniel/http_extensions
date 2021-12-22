import 'package:logging/logging.dart';

class LogOptions {
  /// The logging level
  final Level level;

  /// Indicates whether headers should be logged.
  final bool logHeaders;

  /// Indicates whether sent headers should be logged (overrides [logHeaders]).
  final bool logRequestHeaders;

  /// Indicates whether received headers should be logged (overrides [logHeaders]).
  final bool logResponseHeaders;

  /// Indicates whether sent body and received content should be logged.
  final bool logContent;

  /// Indicates whether sent body should be logged (overrides [logContent]).
  final bool logRequestContent;

  /// Indicates whether received content should be logged (overrides [logContent]).
  final bool logResponseContent;

  /// Indicates whether the logger is enabled.
  final bool isEnabled;

  const LogOptions(
      {this.level = Level.FINE,
      this.isEnabled = true,
      bool? logHeaders,
      bool? logRequestHeaders,
      bool? logResponseHeaders,
      bool? logContent,
      bool? logRequestContent,
      bool? logResponseContent})
      : logRequestHeaders = logRequestHeaders ?? logHeaders ?? false,
        logResponseHeaders = logResponseHeaders ?? logHeaders ?? false,
        logHeaders = logHeaders ?? false,
        logRequestContent = logRequestContent ?? logContent ?? false,
        logResponseContent = logResponseContent ?? logContent ?? false,
        logContent = logContent ?? false;
}
