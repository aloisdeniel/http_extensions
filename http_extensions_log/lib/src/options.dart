import 'package:logging/logging.dart';

class LogOptions {
  /// The logging level
  final Level level;

  /// Indicates whether headers should be logged.
  final bool logHeaders;

  /// Indicates whether sent body and received content should be logged.
  final bool logContent;

  /// Indicates whether the logger is enabled.
  final bool isEnabled;

  const LogOptions(
      {this.level = Level.FINE,
      this.isEnabled = true,
      this.logHeaders = true,
      this.logContent = false});
}
