import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:logging/logging.dart';

import 'options.dart';

class LogExtension extends Extension<LogOptions> {
  final Logger? logger;

  LogExtension({LogOptions defaultOptions = const LogOptions(), this.logger}) : super(defaultOptions: defaultOptions);

  void log(String message, LogOptions options) {
    if (logger != null) {
      logger!.log(options.level, message);
    } else {
      print(message);
    }
  }

  int _id = 0;

  Future<String> _formatRequest(int id, BaseRequest request, LogOptions options) async {
    if (request is ExtensionRequest) {
      return _formatRequest(id, request.request, options);
    }

    final requestLog = StringBuffer();

    requestLog.writeln('-> REQ($id) [ ${request.method} | ${request.url} ]');
    if (options.logRequestHeaders) {
      requestLog.writeln('  * headers: ${request.headers.isEmpty ? 'empty' : ''}');
      request.headers.forEach((k, v) {
        requestLog.writeln('    * $k: $v');
      });
    }

    if (options.logRequestContent) {
      requestLog.writeln('  * content-length: ${request.contentLength}');

      final bytes = request.finalize();
      final content = await bytes.toBytes();
      requestLog.writeln('  * content: ${utf8.decode(content, allowMalformed: true)}');
    }

    return requestLog.toString();
  }

  Future<String> _formatResponse(int id, StreamedResponse response, LogOptions options) async {
    final requestLog = StringBuffer();

    requestLog.writeln('<- RES($id) [ ${response.request!.method} | ${response.request!.url}]');

    requestLog.writeln('  * status-code: ${response.statusCode}');

    if (options.logRequestHeaders) {
      requestLog.writeln('  * headers: ${response.headers.isEmpty ? 'empty' : ''}');
      response.headers.forEach((k, v) {
        requestLog.writeln('    * $k: $v');
      });
    }

    if (options.logResponseContent) {
      requestLog.writeln('  * content-length: ${response.contentLength}');
      final content = await response.stream.toBytes();
      requestLog.writeln('  * content: ${utf8.decode(content, allowMalformed: true)}');
    }

    return requestLog.toString();
  }

  String _formatError(int id, BaseRequest request, dynamic error, StackTrace stackTrace, LogOptions options) {
    final errorLog = StringBuffer();
    errorLog.writeln('!) ERR($id) [ ${request.method} | ${request.url} ]');

    if (error != null) {
      errorLog.writeln('  * error: $error');
    }

    errorLog.writeln('  * stack-trace: $stackTrace');

    return errorLog.toString();
  }

  @override
  Future<StreamedResponse> sendWithOptions(BaseRequest request, LogOptions options) async {
    if (!options.isEnabled) {
      return await super.sendWithOptions(request, options);
    }

    final id = _id++;

    if (options.logRequestContent) {
      request = BufferedRequest(request);
    }

    // Logging request
    final requestLog = await _formatRequest(id, request, options);
    log(requestLog, options);

    try {
      var response = await super.sendWithOptions(request, options);

      if (options.logResponseContent) {
        response = BufferedStreamResponse(response);
      }

      // Logging response
      final responseLog = await _formatResponse(id, response, options);
      log(responseLog, options);

      return response;
    } catch (error, stacktrace) {
      final errorLog = _formatError(id, request, error, stacktrace, options);
      log(errorLog, options);
      rethrow;
    }
  }
}
