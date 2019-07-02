import 'package:http/http.dart';

/// Allows to read multiple times the content of a [StreamedResponse].
class BufferedStreamResponse implements StreamedResponse {
  BufferedStreamResponse(this.base);

  final StreamedResponse base;

  List<int> _bytes;

  Stream<List<int>> _getStream() {
    if(_bytes != null) {
      return Stream.fromIterable([_bytes]);
    }

    return Stream.fromFuture(_readBytes());
  }

  Future<List<int>> _readBytes() async {
    _bytes = await base.stream.toBytes();
    return _bytes;
  }

  @override
  ByteStream get stream => ByteStream(_getStream());

  @override
  int get contentLength => base.contentLength;

  @override
  Map<String, String> get headers => base.headers;

  @override
  bool get isRedirect => base.isRedirect;

  @override
  bool get persistentConnection => base.persistentConnection;

  @override
  String get reasonPhrase => base.reasonPhrase;

  @override
  BaseRequest get request => base.request;

  @override
  int get statusCode  => base.statusCode;
}
