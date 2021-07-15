import 'dart:io';

import 'hello.pb.dart';

void main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Serving at ${server.address}:${server.port}');

  await for (var request in server) {
    print('Request');
    print('  * Content-Length: ${request.contentLength}');
    request.headers.forEach((k, v) {
      print(' * Header => $k : $v');
    });

    final bytes = await request.toList();
    final message = HelloRequest.fromBuffer(bytes.expand((x) => x).toList());

    print(' * Message => $message');

    final response = (HelloReply()..message = 'Hello ${message.name} !').writeToBuffer();

    print('Response');
    print('  * Content-Length: ${response.length}');

    request.response
      ..headers.contentType = ContentType('application', 'x-protobuf')
      ..headers.contentLength = response.length
      ..add(response);
    await request.response.close();
  }
}
