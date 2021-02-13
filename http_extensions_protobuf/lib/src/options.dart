import 'package:http/http.dart';
import 'package:protobuf/protobuf.dart';

typedef ShouldSerialize = bool Function(BaseRequest request);

typedef ShouldDeserialize = bool Function(StreamedResponse response);

class ProtobufOptions {
  /// The request message that will be serialized and added to request body.
  final GeneratedMessage? requestMessage;

  /// The response message prototype that will be used for deserializing content.
  final GeneratedMessage? responseMessage;

  /// The value of the content type header sent to server.
  final String contentType;

  /// Indicates whether a request should be serialized.
  final ShouldSerialize shouldSerialize;

  /// Indicates whether a response should be deserialized.
  final ShouldDeserialize shouldDeserialize;

  const ProtobufOptions(
      {this.contentType = 'application/x-protobuf',
      this.requestMessage,
      this.shouldDeserialize = defaultShouldDeserialize,
      this.shouldSerialize = defaultShouldSerialize,
      this.responseMessage});

  static bool defaultShouldDeserialize(StreamedResponse response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static bool defaultShouldSerialize(BaseRequest request) {
    return true;
  }
}
