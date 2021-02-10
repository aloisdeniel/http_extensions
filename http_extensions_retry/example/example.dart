import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_retry/http_extensions_retry.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';

void main() async {
  // Displaying logs
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final client = ExtendedClient(
    inner: Client() as BaseClient,
    extensions: [
      RetryExtension(
          logger: Logger('Retry'),
          defaultOptions: RetryOptions(
            retryInterval: const Duration(seconds: 5),
          )),
    ],
  );

  /// Sending a failing request for 3 times with a 5s interval
  try {
    await client.get(Uri.parse('http://www.mqldkfjmdisljfmlksqdjfmlkj.dev'));
  } catch (e) {
    print('End error : $e');
  }
}
