import 'package:http/http.dart';
import 'package:protobuf/protobuf.dart';

class ProtobufRequest extends BaseRequest {
  final GeneratedMessage message;

  final List<int> bytes;

  /// Creates a new protobuf request.
  ProtobufRequest.fromRequest(
    BaseRequest original,
    this.message,
  )   : bytes = message.writeToBuffer(),
        super(original.method, original.url) {
    maxRedirects = original.maxRedirects;
    followRedirects = original.followRedirects;
    headers.addAll(original.headers);
    persistentConnection = original.persistentConnection;
  }

  @override
  int get contentLength => bytes.length;

  @override
  ByteStream finalize() {
    super.finalize();
    return ByteStream(Stream.fromIterable([bytes]));
  }
}
