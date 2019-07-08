import 'dart:convert';
import 'dart:io';

main() async {
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  print("Serving at ${server.address}:${server.port}");

  await for (var request in server) {
    print("Request");

    final authorization = request.headers[HttpHeaders.authorizationHeader];

    if (authorization.any((x) => x == "WOOOW")) {
      request.response.statusCode = 200;
      request.response.add(utf8.encode("A secret"));
    } else {
      request.response.statusCode = 401;
    }

    await request.response.close();
  }
}
