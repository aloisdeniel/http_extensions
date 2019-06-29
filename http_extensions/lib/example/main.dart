import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'log_extension.dart';

Future main() async {
  final client = ExtendedClient(
    inner: Client(),
    extensions: [
      LogExtension(),
    ],
  );

  // Default options
  final defaultResult = await client.get("https://www.google.com");
  print("default status code: ${defaultResult.statusCode}");

  // Custom options (not logged)
  final customResult = await client.getWithOptions("https://www.google.com",
      options: [LogOptions(isEnabled: false)]);
  print("default status code: ${customResult.statusCode}");
}
