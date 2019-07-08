import 'dart:io';

import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_headers/http_extensions_headers.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';

main() async {
  // Displaying logs
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final client = ExtendedClient(
    inner: Client(),
    extensions: [
      HeadersExtension(
          logger: Logger("Headers"),
          defaultOptions: HeadersOptions(headersBuilder: (r) => {
            HttpHeaders.authorizationHeader: "WOOOW"
          })),
    ],
  );

  final response = await client.get("http://localhost:8080");
  print("Content: ${response.body}");
}
