import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';

import 'options.dart';

class HeadersExtension extends Extension<HeadersOptions> {
  final Logger? logger;

  HeadersExtension({
    HeadersOptions defaultOptions = const HeadersOptions(),
    this.logger,
  }) : super(defaultOptions: defaultOptions);

  @override
  Future<StreamedResponse> sendWithOptions(
      BaseRequest request, HeadersOptions options) async {
    if (options.headersBuilder != null) {
      final addedHeaders = await options.headersBuilder!(request);
      if (addedHeaders.isNotEmpty) {
        request.headers.addAll(addedHeaders);
        logger?.fine('Added headers to \'${request.url}\'');
      }
    }

    return await super.sendWithOptions(request, options);
  }
}
