import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';

class LogOptions {
  final bool isEnabled;
  const LogOptions({this.isEnabled = true});
}

class LogExtension extends Extension<LogOptions> {
  LogExtension([LogOptions defaultOptions = const LogOptions()])
      : super(defaultOptions: defaultOptions);

  int _requestId = 0;

  Future<StreamedResponse> sendWithOptions(
      BaseRequest request, LogOptions options) async {
    if (!options.isEnabled) {
      return await super.sendWithOptions(request, options);
    }

    try {
      _requestId++;
      print(
          '[HTTP]($_requestId:${request.method}:${request.url}) Starting request ...');
      final result = await super.sendWithOptions(request, options);
      print(
          '[HTTP]($_requestId:${request.method}:${request.url}) Request succeeded (statusCode: ${result.statusCode})');
      return result;
    } catch (e) {
      print('[HTTP] An error occured during request : $e');
      rethrow;
    }
  }
}
