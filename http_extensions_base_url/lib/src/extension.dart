import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'options.dart';
import 'request.dart';

class BaseUrlExtension extends Extension<BaseUrlOptions> {
  final Logger logger;

  BaseUrlExtension({@required BaseUrlOptions defaultOptions, this.logger})
      : super(defaultOptions: defaultOptions);

  @override
  Future<StreamedResponse> sendWithOptions(
      BaseRequest request, BaseUrlOptions options) async {
    if (!request.url.hasScheme) {
      final originalUrl = request.url.toString();
      final baseUrl = BaseUrlRequest(base: request, baseUrl: options.url);

      logger?.fine(
          "Base url '${options.url}' appended to path '${originalUrl}' : ${baseUrl.url}");

      request = baseUrl;
    }

    return await super.sendWithOptions(request, options);
  }
}
