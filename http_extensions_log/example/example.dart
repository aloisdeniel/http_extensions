import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_log/http_extensions_log.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';

void main() async {
  // Displaying logs
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
        '${record.loggerName} | ${record.level.name}: ${record.time}: ${record.message}');
  });

  final client = ExtendedClient(
    inner: Client() as BaseClient,
    extensions: [
      LogExtension(
          logger: Logger('Http'),
          defaultOptions: LogOptions(
            logContent: true,
          )),
    ],
  );

  await client.get(Uri.parse('http://www.flutter.dev'));
  try {
    await client.get(Uri.parse('http://www.djdkjskdjgndfkjgnskjgn.dev'));
  } catch (e) {
    print('Failed : $e');
  }
}
