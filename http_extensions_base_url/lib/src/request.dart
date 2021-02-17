import 'package:http/http.dart';

class BaseUrlRequest implements BaseRequest {
  final Uri baseUrl;

  final BaseRequest base;

  BaseUrlRequest({required this.baseUrl, required this.base});

  @override
  int? get contentLength => base.contentLength;

  @override
  set contentLength(int? v) => base.contentLength = v;

  @override
  bool get followRedirects => base.followRedirects;

  @override
  set followRedirects(bool v) => base.followRedirects = v;

  @override
  int get maxRedirects => base.maxRedirects;

  @override
  set maxRedirects(int v) => base.maxRedirects = v;

  @override
  bool get persistentConnection => base.persistentConnection;

  @override
  set persistentConnection(bool v) => base.persistentConnection = v;

  @override
  bool get finalized => false; // Forced

  @override
  Map<String, String> get headers => base.headers;

  @override
  ByteStream finalize() => base.finalize();

  @override
  String get method => base.method;

  @override
  Future<StreamedResponse> send() => throw Exception('Not supported');

  @override
  Uri get url => baseUrl.resolve(base.url.toString());
}
