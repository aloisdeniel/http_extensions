# http_extensions : retry

An [http extension] that retries failed requests.

## Usage

```dart
final client = ExtendedClient(
  inner: Client(),
  extensions: [
    RetryExtension(
        logger: Logger("Retry"),
        defaultOptions: RetryOptions(
          const RetryOptions(
      retries: 3, // Number of retries before a failure
      retryInterval: const Duration(seconds: 5), // Interval between each retry
      retryEvaluator: (error, response) => error != null, // Evaluating if a retry is necessary regarding the error or the response. It is a good candidate for updating authentication token in case of a unauthorized error (be careful with concurrency though). error or response are at least null
        )),
  ],
);
```