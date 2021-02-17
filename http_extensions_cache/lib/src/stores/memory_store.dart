import 'package:http_extensions_cache/src/stores/store.dart';

/// A store that keeps responses into a simple [Map] in memory.
class MemoryCacheStore extends CacheStore {
  /// Map could contain a CachedResponse at a given key, or null.
  final Map<String, CachedResponse?> _responses = {};

  MemoryCacheStore();

  @override
  Future<void> clean() async {
    _responses.clear();
  }

  @override
  Future<CachedResponse?> get(String id) async {
    return _responses[id];
  }

  @override
  Future<void> set(CachedResponse response) async {
    _responses[response.id] = response;
  }

  @override
  Future<void> updateExpiry(String id, DateTime newExpiry) async {
    final cache = _responses[id];

    if (cache != null) {
      _responses[id] = cache.copyWith(expiry: newExpiry);
    }
  }

  @override
  Future<void> delete(String id) async {
    _responses.remove(id);
  }
}
