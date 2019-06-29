import 'package:http_extensions_cache/src/stores/store.dart';

/// A store that keeps responses into a simple [Map] in memory.
class MemoryCacheStore extends CacheStore {

  final Map<String, CachedResponse> _responses = {};

  MemoryCacheStore();

  @override
  Future<void> clean() {
    _responses.clear();
    return Future.value();
  }

  @override
  Future<CachedResponse> get(String id) {
    return Future.value(_responses[id]);
  }

  @override
  Future<void> set(CachedResponse response) async {
    _responses[response.id] = response;
  }

  @override
  Future<void> updateExpiry(String id, DateTime newExpiry) {
    final cache = this._responses[id];
    if(cache != null) {
      this._responses[id] = cache.copyWith(expiry: newExpiry);
    }

    return Future.value();
  }

  @override
  Future<void> delete(String id) {
    _responses.remove(id);
    return Future.value();
  }
}