import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_cache/http_extensions_cache.dart';
import 'package:http_extensions_cache/src/stores/memory_store.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';

void main() async {
  // Displaying logs
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final store = MemoryCacheStore();

  final client = ExtendedClient(
    inner: Client() as BaseClient,
    extensions: [
      CacheExtension(
          logger: Logger('Cache'), defaultOptions: CacheOptions(store: store)),
    ],
  );

  // The first request will get data and add it to cache
  final distantResponse = await client.get(Uri.parse('http://www.flutter.dev'));
  print(
      'Distant -> statusCode: ${distantResponse.statusCode}, data : ${distantResponse.body.substring(0, 20)}...');

  await Future.delayed(const Duration(seconds: 5));

  // The second request will use the cached value
  final cachedResponse = await client.get(Uri.parse('http://www.flutter.dev'));
  print(
      'Cached -> statusCode: ${cachedResponse.statusCode}, data : ${distantResponse.body.substring(0, 20)}...');

  // The new request will get data and add it to cache
  final forcedResponse = await client.getWithOptions(
    'http://www.flutter.dev',
    options: [CacheOptions(forceUpdate: true)],
  );
  print(
      'Forced -> statusCode: ${forcedResponse.statusCode}, data : ${forcedResponse.body.substring(0, 20)}...');
}
