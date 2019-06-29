# http_extensions : cache

An [http extension] that caches requests.

## Usage

```dart
final client = ExtendedClient(
  inner: Client(),
  extensions: [
    CacheExtension(
        logger: Logger("Cache"),
        defaultOptions: CacheOptions(
          const CacheOptions(
            expiry: const Duration(minutes: 5),// The duration after the cached result of the request will be expired.
            forceUpdate: false, // Forces to request a new value, even if an valid cache is available
            forceCache: false, // Forces to return the cached value if available (even if expired).
            ignoreCache: true, //Indicates whether the request should bypass all caching logic
            returnCacheOnError: true, //If [true], on error, if a value is available in the  store if is returned as a successful response (even if expired). 
            keyBuilder: (request) => "${request.method}_${uuid.v5(Uuid.NAMESPACE_URL, request.uri.toString())}", // Builds the unqie key used for indexing a request in cache.
            store: MemoryCacheStore(), // The store used for caching data.
            shouldBeSaved: (response) => response.statusCode >= 200 && response.statusCode < 300, // A way of filtering responses (for exemple regarding the result status code, or the content length).
        )),
  ],
);
```