import 'package:http/http.dart';

import 'buffered_request.dart';

/// Allows to read multiple times the content of a [MultipartRequest].
///
/// See [BufferedRequest]
class BufferedMultipartRequest extends BufferedRequest<MultipartRequest> {
  BufferedMultipartRequest(MultipartRequest base) : super(base);

  List<MultipartFile> get files => base.files;

  Map<String, String> get fields => base.fields;
}
