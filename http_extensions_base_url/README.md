# http_extensions : base url

An [http extension] that adds base url to requests with a relative path.

## Usage

```dart
final client = ExtendedClient(
  inner: Client(),
  extensions: [
    BaseUrlExtension(
        logger: Logger("BaseUrl"),
        defaultOptions: BaseUrlOptions(
          url: Uri.parse("http://flutter.dev") // The base url that is appended to the relative paths.
        ),
  ],
);
```