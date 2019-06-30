import 'dart:io';

import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';

import 'options.dart';

class ProtobufExtension extends Extension<ProtobufOptions> {
  final Logger logger;

  ProtobufExtension(
      {ProtobufOptions defaultOptions = const ProtobufOptions(), this.logger})
      : assert(defaultOptions.requestMessage == null,
            "Global protobuf options should have an empty request message"),
        assert(defaultOptions.responseMessage == null,
            "Global protobuf options should have an empty response message"),
        super(defaultOptions: defaultOptions);

  void _updateBody(BaseRequest original, List<int> body) {
    if (original is ExtensionRequest) {
      _updateBody(original.request, body);
      return;
    } else if (original is Request) {
      original.bodyBytes = body;
      return;
    } else if (original is StreamedRequest) {
      original.sink.add(body);
      return;
    }

    throw ArgumentError("Failed to update body with protobuf content");
  }

  Future<StreamedResponse> sendWithOptions(
      BaseRequest request, ProtobufOptions options) async {
    if (options.requestMessage != null &&
        options.shouldSerialize(request)) {
      logger?.fine(
          "[${request.url}] Serializing ${options.requestMessage.runtimeType} body with protobuf");
      final requestBytes = options.requestMessage.writeToBuffer();
      request.headers[HttpHeaders.contentTypeHeader] = options.contentType;
      request.headers[HttpHeaders.contentLengthHeader] =
          requestBytes.length.toString();
      _updateBody(request, requestBytes);
    }

    if (options.responseMessage != null) {
      request.headers[HttpHeaders.acceptHeader] = options.contentType;
    }

    var result = await super.sendWithOptions(request, options);

    if (options.responseMessage != null &&
        options.shouldDeserialize(result)) {
      logger?.fine(
          "[${request.url}] Deserializing ${options.responseMessage.runtimeType} content with protobuf");
      final responseBytes = await result.stream.toBytes();
      options.responseMessage.mergeFromBuffer(responseBytes);
      return StreamedResponse(
          Stream.fromIterable([responseBytes]), result.statusCode,
          contentLength: responseBytes.length,
          headers: result.headers,
          isRedirect: result.isRedirect,
          reasonPhrase: result.reasonPhrase,
          request: request,
          persistentConnection: result.persistentConnection);
    }

    return result;
  }
}
