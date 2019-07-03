import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_protobuf/http_extensions_protobuf.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';

import 'hello.pb.dart';

main() async {
  // Displaying logs
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final client = ExtendedClient(
    inner: Client(),
    extensions: [
      ProtobufExtension(logger: Logger("Cache")),
    ],
  );

  // The new request will get data and add it to cache
  final proto = ProtobufOptions(
    requestMessage: (HelloRequest()
      ..name = "John"
    ),
    responseMessage: HelloReply(),
  );

  final response = await client.getWithOptions(
    "http://localhost:8080",
    options: [proto],
  );

  if (response.statusCode == 200) {
    print("Reply: ${proto.responseMessage}");
  }
}
