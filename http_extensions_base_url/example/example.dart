import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_base_url/http_extensions_base_url.dart';
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
      BaseUrlExtension(
          logger: Logger('BaseUrl'),
          defaultOptions: BaseUrlOptions(url: Uri.parse('http://flutter.dev'))),
    ],
  );

  final response = await client.get(Uri.parse('/docs'));
  print('Html content: ${response.body}');
}
