import 'dart:async';

import 'package:http/http.dart';

/// Allows to read multiple times the content of a [StreamedRequest].
class BufferedStreamRequest extends BaseRequest implements StreamedRequest {
  BufferedStreamRequest(this.base) : super(base.method, base.url);

  final StreamedRequest base;

  List<int> _bytes;

  Future<List<int>> _futureBytes;

  @override
  int get contentLength => base.contentLength;
  set contentLength(int v) => base.contentLength = v;

  @override
  bool get followRedirects => base.followRedirects;
  set followRedirects(bool v) => base.followRedirects = v;

  @override
  int get maxRedirects => base.maxRedirects;
  set maxRedirects(int v) => base.maxRedirects = v;

  @override
  bool get persistentConnection => base.persistentConnection;
  set persistentConnection(bool v) => base.persistentConnection = v;

  @override
  bool get finalized => false; // Forced

  @override
  Map<String, String> get headers => base.headers;

  @override
  ByteStream finalize() {
    if (_bytes != null) return ByteStream.fromBytes(_bytes);
    if (this._futureBytes == null) this._futureBytes = _getBytes();
    return ByteStream(Stream.fromFuture(_futureBytes));
  }

  Future<List<int>> _getBytes() async {
    final s = await base.finalize();
    _bytes = await s.toBytes();
    return _bytes;
  }

  @override
  EventSink<List<int>> get sink => base.sink;
}
