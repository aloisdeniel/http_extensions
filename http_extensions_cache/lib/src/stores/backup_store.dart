import 'package:meta/meta.dart';

import 'memory_store.dart';
import 'store.dart';

class BackupCacheStore extends CacheStore {
  final CacheStore primaryStore;
  final CacheStore backupStore;

  BackupCacheStore({@required this.backupStore, CacheStore primaryStore})
      : assert(backupStore != null),
        this.primaryStore = primaryStore ?? MemoryCacheStore();

  @override
  Future<void> clean() {
    this.backupStore.clean();
    return this.primaryStore.clean();
  }

  @override
  Future<void> delete(String id) {
    this.backupStore.delete(id);
    return this.primaryStore.delete(id);
  }

  @override
  Future<CachedResponse> get(String id) async {
    final existing = await this.primaryStore.get(id);
    if (existing != null) {
      return existing;
    }

    final backup = await this.backupStore.get(id);
    if (backup != null) {
      await primaryStore.set(backup);
      return backup;
    }

    return null;
  }

  @override
  Future<void> set(CachedResponse response) {
    this.backupStore.set(response);
    return this.primaryStore.set(response);
  }

  @override
  Future<void> updateExpiry(String id, DateTime newExpiry) {
    this.backupStore.updateExpiry(id, newExpiry);
    return this.primaryStore.updateExpiry(id, newExpiry);
  }
}
