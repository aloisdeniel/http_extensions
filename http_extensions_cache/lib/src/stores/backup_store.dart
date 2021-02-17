import 'package:meta/meta.dart';

import 'memory_store.dart';
import 'store.dart';

class BackupCacheStore extends CacheStore {
  final CacheStore primaryStore;
  final CacheStore backupStore;

  BackupCacheStore({
    required this.backupStore,
    CacheStore? primaryStore,
  }) : primaryStore = primaryStore ?? MemoryCacheStore();

  @override
  Future<void> clean() {
    backupStore.clean();
    return primaryStore.clean();
  }

  @override
  Future<void> delete(String id) {
    backupStore.delete(id);
    return primaryStore.delete(id);
  }

  @override
  Future<CachedResponse?> get(String id) async {
    final existing = await primaryStore.get(id);
    if (existing != null) {
      return existing;
    }

    final backup = await backupStore.get(id);
    if (backup != null) {
      await primaryStore.set(backup);
      return backup;
    }

    return null;
  }

  @override
  Future<void> set(CachedResponse response) {
    backupStore.set(response);
    return primaryStore.set(response);
  }

  @override
  Future<void> updateExpiry(String id, DateTime newExpiry) {
    backupStore.updateExpiry(id, newExpiry);
    return primaryStore.updateExpiry(id, newExpiry);
  }
}
