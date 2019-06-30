# http_extensions : log

An [http extension] that logs requests.

## Usage

```dart
final client = ExtendedClient(
  inner: Client(),
  extensions: [
    LogExtension(
        logger: Logger("HTTP"),
        defaultOptions: LogOptions(
          const LogOptions(
            level: Level.fine // The logging level (on logger)
            isEnabled: true, // Indicates whether the logger is enabled.
            logContent: false // Indicates whether sent body and received content should be logged.
            logHeaders: true // Indicates whether headers should be logged.
        )),
  ],
);
```