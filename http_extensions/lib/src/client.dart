import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_extensions/http_extensions.dart';
import 'request.dart';

class ExtendedClient extends http.BaseClient {
  final http.BaseClient root;
  final List<Extension> extensions;

  ExtendedClient({
    required http.BaseClient inner,
    this.extensions = const [],
  }) : root = _buildRoot(inner, extensions);

  static http.BaseClient _buildRoot(
      http.BaseClient inner, List<Extension> extensions) {
    var result = inner;
    for (var extension in extensions.reversed) {
      extension._inner = result;
      result = extension;
    }

    return result;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return root.send(request);
  }

  Future<http.StreamedResponse> sendWithOptions(
      http.BaseRequest request, List<dynamic>? options) {
    return root.send(ExtensionRequest(options: options, request: request));
  }

  Future<http.Response> getWithOptions(url,
          {Map<String, String>? headers, List<dynamic>? options}) =>
      _sendUnstreamedWithOptions('GET', url, headers, options);

  Future<http.Response> headWithOptions(url,
          {Map<String, String>? headers, List<dynamic>? options}) =>
      _sendUnstreamedWithOptions('HEAD', url, headers, options);

  Future<http.Response> deleteWithOptions(url,
          {Map<String, String>? headers, List<dynamic>? options}) =>
      _sendUnstreamedWithOptions('DELETE', url, headers, options);

  Future<http.Response> putWithOptions(url,
          {Map<String, String>? headers,
          body,
          List<dynamic>? options,
          Encoding? encoding}) =>
      _sendUnstreamedWithOptions('PUT', url, headers, options, body, encoding);

  Future<http.Response> postWithOptions(url,
          {Map<String, String>? headers,
          body,
          List<dynamic>? options,
          Encoding? encoding}) =>
      _sendUnstreamedWithOptions('POST', url, headers, options, body, encoding);

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  Future<http.Response> _sendUnstreamedWithOptions(
      String method, url, Map<String, String>? headers, List<dynamic>? options,
      [body, Encoding? encoding]) async {
    if (url is String) url = Uri.parse(url);
    var request = http.Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body \'$body\'.');
      }
    }

    return http.Response.fromStream(await sendWithOptions(request, options));
  }
}

abstract class Extension<TOptions> extends http.BaseClient {
  http.BaseClient? _inner;

  final TOptions defaultOptions;

  Extension({http.BaseClient? inner, required this.defaultOptions})
      : _inner = inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    dynamic options;

    if (request is ExtensionRequest) {
      options = request.option<TOptions>();
    }

    options ??= defaultOptions;

    return sendWithOptions(request, options);
  }

  Future<http.StreamedResponse> sendWithOptions(
      http.BaseRequest request, TOptions options) {
    assert(_inner != null, 'inner http client must not be null');
    return _inner!.send(request);
  }
}
