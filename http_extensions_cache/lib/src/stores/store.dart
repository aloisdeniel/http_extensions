import 'package:http/http.dart';
import 'package:meta/meta.dart';

abstract class CacheStore {
  const CacheStore();
  Future<CachedResponse?> get(String id);
  Future<void> set(CachedResponse response);
  Future<void> updateExpiry(String id, DateTime newExpiry);
  Future<void> delete(String id);
  Future<void> clean();
  Future<void> invalidate(String id) =>
      this.updateExpiry(id, DateTime.fromMillisecondsSinceEpoch(0));
}

class CachedResponse implements StreamedResponse {
  CachedResponse({
    required this.id,
    required this.bytes,
    required this.request,
    required this.expiry,
    required DateTime? downloadedAt,
    required this.headers,
    required this.isRedirect,
    required this.persistentConnection,
    required this.reasonPhrase,
    required this.statusCode,
  })   : this.downloadedAt = downloadedAt ?? DateTime.now(),
        this.contentLength = bytes.length;

  static Future<CachedResponse> fromResponse(
    StreamedResponse response, {
    required String id,
    required BaseRequest request,
    required DateTime expiry,
    DateTime? downloadedAt,
  }) async {
    final bytes = await response.stream.toBytes();

    return CachedResponse(
      id: id,
      bytes: bytes,
      request: request,
      downloadedAt: downloadedAt,
      expiry: expiry,
      headers: Map<String, String>.from(response.headers),
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
      statusCode: response.statusCode,
    );
  }

  final String id;
  final List<int> bytes;
  final BaseRequest request;
  final DateTime expiry;
  final DateTime downloadedAt;

  @override
  final int contentLength;

  @override
  final Map<String, String> headers;

  @override
  final bool isRedirect;

  @override
  final bool persistentConnection;

  @override
  final String? reasonPhrase;

  @override
  final int statusCode;

  @override
  ByteStream get stream => ByteStream(Stream.fromIterable([this.bytes]));

  CachedResponse copyWith({
    String? id,
    List<int>? bytes,
    BaseRequest? request,
    DateTime? expiry,
    DateTime? downloadedAt,
    Map<String, String>? headers,
    bool? isRedirect,
    bool? persistentConnection,
    String? reasonPhrase,
    int? statusCode,
  }) =>
      CachedResponse(
        id: id ?? this.id,
        bytes: bytes ?? this.bytes,
        request: request ?? this.request,
        expiry: expiry ?? this.expiry,
        downloadedAt: downloadedAt ?? this.downloadedAt,
        headers: headers ?? this.headers,
        isRedirect: isRedirect ?? this.isRedirect,
        persistentConnection: persistentConnection ?? this.persistentConnection,
        reasonPhrase: reasonPhrase ?? this.reasonPhrase,
        statusCode: statusCode ?? this.statusCode,
      );
}
