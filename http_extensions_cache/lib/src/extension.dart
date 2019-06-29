import 'dart:io';

import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';

import 'options.dart';
import 'stores/memory_store.dart';
import 'stores/store.dart';

class CacheExtension extends Extension<CacheOptions> {
  final Logger logger;
  final CacheStore _globalStore;

  CacheExtension(
      {CacheOptions defaultOptions = const CacheOptions(), this.logger})
      : this._globalStore = defaultOptions.store ?? MemoryCacheStore(),
        super(defaultOptions: defaultOptions);

  Future<StreamedResponse> sendWithOptions(
      BaseRequest request, CacheOptions options) async {
    if (options.ignoreCache) {
      return await super.sendWithOptions(request, options);
    }

    final cacheId = options.keyBuilder(request);
    assert(cacheId != null, "The cache key builder produced an empty key");
    final store = options.store ?? _globalStore;
    CachedResponse result = await store.get(cacheId);

    var souldUpdate = options.forceUpdate ||
        result == null ||
        (!options.forceCache && result.expiry.isBefore(DateTime.now()));

    if (souldUpdate) {
      logger?.fine(
          "[$cacheId][${request.url}] Not existing or expired cache, or forced update : starting a new request");

      try {

        if(result != null && !request.headers.containsKey(HttpHeaders.ifModifiedSinceHeader)) {
          logger?.fine(
          "[$cacheId][${request.url}] Adding `${HttpHeaders.ifModifiedSinceHeader}` header");
          request.headers[HttpHeaders.ifModifiedSinceHeader] = HttpDate.format(result.downloadedAt);
        }
;
        final response = await super.sendWithOptions(request, options);

        if(result != null && response.statusCode == 304) {
          logger?.fine(
          "[$cacheId][${request.url}] Content not modified (status code 304), returning cache");
          return result;
        }

        final expiry = DateTime.now().add(options.expiry);
        result = await CachedResponse.fromResponse(response,
            expiry: expiry, id: cacheId, request: request);


        if (options.shouldBeSaved(result)) {
          logger?.fine(
              "[$cacheId][${request.url}] Saving resulting response to cache ...");
          await store.set(result);
        }

        return result;
      } catch (e) {
        if (options.returnCacheOnError && result != null) {
          return result;
        } else {
          rethrow;
        }
      }
    }

    logger?.fine(
        "[$cacheId][${request.url}] Not updating, try to use local cache ...");

    if (result == null) {
      throw NoCacheAvailableException();
    }

    logger?.fine(
        "[$cacheId][${request.url}] Result found in cache for corresponding request");

    return result;
  }
}

class NoCacheAvailableException implements Exception {
  NoCacheAvailableException();
}
