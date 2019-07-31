// Since 'dart:io' isn't compatible with web platform
// we have to include our own implementation.

// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


abstract class HttpHeaders {
  static const acceptHeader = "accept";
  static const acceptCharsetHeader = "accept-charset";
  static const acceptEncodingHeader = "accept-encoding";
  static const acceptLanguageHeader = "accept-language";
  static const acceptRangesHeader = "accept-ranges";
  static const ageHeader = "age";
  static const allowHeader = "allow";
  static const authorizationHeader = "authorization";
  static const cacheControlHeader = "cache-control";
  static const connectionHeader = "connection";
  static const contentEncodingHeader = "content-encoding";
  static const contentLanguageHeader = "content-language";
  static const contentLengthHeader = "content-length";
  static const contentLocationHeader = "content-location";
  static const contentMD5Header = "content-md5";
  static const contentRangeHeader = "content-range";
  static const contentTypeHeader = "content-type";
  static const dateHeader = "date";
  static const etagHeader = "etag";
  static const expectHeader = "expect";
  static const expiresHeader = "expires";
  static const fromHeader = "from";
  static const hostHeader = "host";
  static const ifMatchHeader = "if-match";
  static const ifModifiedSinceHeader = "if-modified-since";
  static const ifNoneMatchHeader = "if-none-match";
  static const ifRangeHeader = "if-range";
  static const ifUnmodifiedSinceHeader = "if-unmodified-since";
  static const lastModifiedHeader = "last-modified";
  static const locationHeader = "location";
  static const maxForwardsHeader = "max-forwards";
  static const pragmaHeader = "pragma";
  static const proxyAuthenticateHeader = "proxy-authenticate";
  static const proxyAuthorizationHeader = "proxy-authorization";
  static const rangeHeader = "range";
  static const refererHeader = "referer";
  static const retryAfterHeader = "retry-after";
  static const serverHeader = "server";
  static const teHeader = "te";
  static const trailerHeader = "trailer";
  static const transferEncodingHeader = "transfer-encoding";
  static const upgradeHeader = "upgrade";
  static const userAgentHeader = "user-agent";
  static const varyHeader = "vary";
  static const viaHeader = "via";
  static const warningHeader = "warning";
  static const wwwAuthenticateHeader = "www-authenticate";
}