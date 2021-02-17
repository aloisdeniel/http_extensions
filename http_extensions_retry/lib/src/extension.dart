import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';

import 'options.dart';

class RetryExtension extends Extension<RetryOptions> {
  final Logger? logger;

  RetryExtension({
    RetryOptions defaultOptions = const RetryOptions(),
    this.logger,
  }) : super(defaultOptions: defaultOptions);

  BaseRequest _copyRequest(BaseRequest original) {
    if (original is ExtensionRequest) {
      return ExtensionRequest(
          request: _copyRequest(original.request), options: original.options);
    }

    if (original is MultipartRequest) {
      return BufferedMultipartRequest(original);
    }

    return BufferedRequest(original);
  }

  Future<StreamedResponse> _retry(
      BaseRequest request, RetryOptions options) async {
    final newOptions = options.copyWith(
      retries: options.retries - 1,
    );

    if (request is ExtensionRequest) {
      request.options.removeWhere((x) => x is RetryOptions);
      request.options.add(newOptions);
    }

    if (options.retryInterval.inMilliseconds > 0) {
      logger?.fine('Retrying request in ${options.retryInterval} ...');
      await Future.delayed(options.retryInterval);
    }

    logger
        ?.fine('Retrying request (remaining retries: ${options.retries - 1})');
    return await this.sendWithOptions(_copyRequest(request), newOptions);
  }

  @override
  Future<StreamedResponse> sendWithOptions(
      BaseRequest request, RetryOptions options) async {
    // Copying request a first time in case of a [StreamRequest] that should
    // be buffered for potential later retry.
    request = _copyRequest(request);

    try {
      final result = await super.sendWithOptions(request, options);
      if (options.retries > 0 && options.retryEvaluator(null, result) as bool) {
        return _retry(request, options);
      }
      return result;
    } catch (e) {
      if (options.retries > 0 && options.retryEvaluator(e, null) as bool) {
        return _retry(request, options);
      } else {
        rethrow;
      }
    }
  }
}
