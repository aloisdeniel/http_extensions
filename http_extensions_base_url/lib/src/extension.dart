import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'options.dart';

class BaseUrlExtension extends Extension<BaseUrlOptions> {
  final Logger logger;

  BaseUrlExtension({@required BaseUrlOptions defaultOptions, this.logger})
      : super(defaultOptions: defaultOptions);

  Future<BaseRequest> _resolve(
      BaseRequest original, BaseUrlOptions options) async {
    if (original is ExtensionRequest) {
      return ExtensionRequest(
          request: await _resolve(original.request, options),
          options: original.options);
    }

    if (original.url.hasScheme) {
      return original;
    }

    final url = options.url.resolve(original.url.toString());

    logger?.fine(
        "Base url '${options.url}' appended to path '${original.url}' : $url");

    if (original is Request) {
      var result = Request(original.method, url);
      if (original.headers != null) result.headers.addAll(original.headers);
      if (original.encoding != null) result.encoding = original.encoding;
      if (original.bodyBytes != null) result.bodyBytes = original.bodyBytes;
      return result;
    }

    if (original is StreamedRequest) {
      var result = Request(original.method, url);
      if (original.headers != null) result.headers.addAll(original.headers);
      result.bodyBytes = await original.finalize().toBytes();
      return result;
    }

    throw ArgumentError(
        "Failed to resolve request of type ${original.runtimeType}");
  }

  @override
  Future<StreamedResponse> sendWithOptions(
      BaseRequest request, BaseUrlOptions options) async {
    request = await _resolve(request, options);
    return await super.sendWithOptions(request, options);
  }
}
