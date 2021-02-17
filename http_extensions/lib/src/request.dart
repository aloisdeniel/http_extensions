import 'package:http/http.dart' as http;

class ExtensionRequest implements http.BaseRequest {
  final http.BaseRequest request;
  final List<dynamic> options;

  ExtensionRequest({
    required this.request,
    List<dynamic>? options,
  }) : options = options ?? [];

  @override
  Map<String, String> get headers => request.headers;

  @override
  int? get contentLength => request.contentLength;

  TOptions? option<TOptions>() =>
      options.firstWhere((x) => x is TOptions, orElse: () => null);

  @override
  http.ByteStream finalize() {
    return request.finalize();
  }

  @override
  bool get followRedirects => request.followRedirects;

  @override
  set followRedirects(bool value) => request.followRedirects = value;

  @override
  int get maxRedirects => request.maxRedirects;

  @override
  set maxRedirects(int value) => request.maxRedirects = value;

  @override
  bool get persistentConnection => request.persistentConnection;
  @override
  set persistentConnection(bool value) => request.persistentConnection = value;

  @override
  set contentLength(int? value) => request.contentLength = value;

  @override
  bool get finalized => request.finalized;

  @override
  String get method => request.method;

  @override
  Future<http.StreamedResponse> send() => request.send();

  @override
  Uri get url => request.url;
}
