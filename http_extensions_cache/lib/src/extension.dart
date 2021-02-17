import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';

import 'package:http_extensions/helpers.dart';
import 'options.dart';
import 'stores/memory_store.dart';
import 'stores/store.dart';

class CacheExtension extends Extension<CacheOptions> {
  final Logger? logger;
  final CacheStore _globalStore;

  CacheExtension({
    CacheOptions defaultOptions = const CacheOptions(),
    this.logger,
  })  : _globalStore = defaultOptions.store ?? MemoryCacheStore(),
        super(defaultOptions: defaultOptions);

  @override
  Future<StreamedResponse> sendWithOptions(
    BaseRequest request,
    CacheOptions options,
  ) async {
    if (options.ignoreCache) {
      return await super.sendWithOptions(request, options);
    }

    final cacheId = options.keyBuilder(request);
    final store = options.store ?? _globalStore;
    var cacheResult = await store.get(cacheId);

    var shouldUpdate = options.forceUpdate ||
        cacheResult == null ||
        (!options.forceCache && cacheResult.expiry.isBefore(DateTime.now()));

    if (shouldUpdate) {
      logger?.fine(
          '[$cacheId][${request.url}] Not existing or expired cache, or forced update : starting a new request');

      try {
        if (cacheResult != null &&
            !request.headers.containsKey(HttpHeaders.ifModifiedSinceHeader)) {
          logger?.fine(
              '[$cacheId][${request.url}] Adding `${HttpHeaders.ifModifiedSinceHeader}` header');
          request.headers[HttpHeaders.ifModifiedSinceHeader] =
              HttpDate.format(cacheResult.downloadedAt);
        }

        final response = await super.sendWithOptions(request, options);

        if (cacheResult != null && response.statusCode == 304) {
          logger?.fine(
              '[$cacheId][${request.url}] Content not modified (status code 304), returning cache');
          return cacheResult;
        }

        final expiry = DateTime.now().add(options.expiry);
        cacheResult = await CachedResponse.fromResponse(response,
            expiry: expiry, id: cacheId, request: request);

        if (options.shouldBeSaved(cacheResult)) {
          logger?.fine(
              '[$cacheId][${request.url}] Saving resulting response to cache ...');
          await store.set(cacheResult);
        }

        return cacheResult;
      } catch (e) {
        if (options.returnCacheOnError && cacheResult != null) {
          return cacheResult;
        } else {
          rethrow;
        }
      }
    }

    logger?.fine(
        '[$cacheId][${request.url}] Not updating, try to use local cache ...');

    if (cacheResult == null) {
      throw NoCacheAvailableException();
    }

    logger?.fine(
        '[$cacheId][${request.url}] Result found in cache for corresponding request');

    return cacheResult;
  }
}

class NoCacheAvailableException implements Exception {
  NoCacheAvailableException();
}
