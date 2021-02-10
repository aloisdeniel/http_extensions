import 'dart:async';

import 'package:http/http.dart';

typedef FutureOr<Map<String, String>> HeadersBuilder(BaseRequest request);

class HeadersOptions {
  /// The builder for headers that are added to requests.
  final HeadersBuilder? headersBuilder;

  const HeadersOptions({this.headersBuilder});

  const HeadersOptions.none() : this.headersBuilder = noneHeadersBuilder;

  static FutureOr<Map<String, String>> noneHeadersBuilder(BaseRequest _) =>
      <String, String>{};
}
