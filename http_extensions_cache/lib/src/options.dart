import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

import 'stores/store.dart';

typedef CacheKeyBuilder = String Function(BaseRequest request);

typedef CacheShouldBeSaved = bool Function(StreamedResponse response);

class CacheOptions {
  /// The duration after the cached result of the request
  /// will be expired.
  final Duration expiry;

  /// Forces to request a new value, even if an valid
  /// cache is available.
  final bool forceUpdate;

  /// Forces to return the cached value if available (even
  /// if expired).
  final bool forceCache;

  /// Indicates whether the request should bypass all caching logic.
  final bool ignoreCache;

  /// If [true], on error, if a value is available in the
  /// store if is returned as a successful response (even
  /// if expired).
  final bool returnCacheOnError;

  /// The store used for caching data.
  final CacheStore? store;

  /// Builds the unqie key used for indexing a request in cache.
  ///
  /// Defaults to `(request) => '${request.method}_${uuid.v5(Uuid.NAMESPACE_URL, request.uri.toString())}'`
  final CacheKeyBuilder keyBuilder;

  /// A way of filtering responses (for exemple regarding the result status code, or the content length).
  final CacheShouldBeSaved shouldBeSaved;

  const CacheOptions(
      {this.forceUpdate = false,
      this.forceCache = false,
      this.returnCacheOnError = true,
      this.ignoreCache = false,
      this.keyBuilder = defaultCacheKeyBuilder,
      this.shouldBeSaved = defaultShouldBeSaved,
      this.store,
      this.expiry = const Duration(minutes: 5)});

  static final uuid = Uuid();

  static bool defaultShouldBeSaved(StreamedResponse response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static String defaultCacheKeyBuilder(BaseRequest request) {
    return '${request.method}_${uuid.v5(Uuid.NAMESPACE_URL, request.url.toString())}';
  }
}
