import 'package:http/http.dart';
import 'package:protobuf/protobuf.dart';

class ProtobufRequest extends BaseRequest {
  final GeneratedMessage message;

  final List<int> bytes;

  /// Creates a new protobuf request.
  ProtobufRequest.fromRequest(BaseRequest original, this.message)
      : this.bytes = message.writeToBuffer(),
        super(original.method, original.url) {
          this.maxRedirects = original.maxRedirects;
          this.followRedirects = original.followRedirects;
          this.headers.addAll(original.headers);
          this.persistentConnection = original.persistentConnection;
        }

  @override
  int get contentLength => this.bytes.length;

  @override
  ByteStream finalize() {
    super.finalize();
    return ByteStream(Stream.fromIterable([bytes]));
  }
}
