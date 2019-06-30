# http_extensions

Base classes for building standard extensions for [http](https://pub.dev/packages/http) package.

## Usage

To build an extension, you have to provide an `Extension` implementation :

```dart
import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';

class LogOptions {
  final bool isEnabled;
  const LogOptions({this.isEnabled = true});
}

class LogExtension extends Extension<LogOptions> {
  LogExtension([LogOptions defaultOptions = const LogOptions()])
      : super(defaultOptions: defaultOptions);

  int _requestId = 0;

  Future<StreamedResponse> sendWithOptions(
      BaseRequest request, LogOptions options) async {

    if(!options.isEnabled) {
      return await super.sendWithOptions(request, options);
    }

    try {
      final id = _requestId++;
      print(
          "[HTTP]($id:${request.method}:${request.url}) Starting request ...");
      final result = await super.sendWithOptions(request, options);
      print(
          "[HTTP]($id:${request.method}:${request.url}) Request succeeded (statusCode: ${result.statusCode})");
      return result;
    } catch (e) {
      print("[HTTP] An error occured during request : $e");
      rethrow;
    }
  }
}
```

To call request using your extensions, the easiest way is to instantiate an `ExtendedClient` with your extensions.

```dart
import 'package:http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'log_extension.dart';

Future main() async {
  final client = ExtendedClient(
    inner: Client(),
    extensions: [
      LogExtension(),
    ],
  );

  // Default options
  final defaultResult = await client.get("https://www.google.com");
  print("default status code: ${defaultResult.statusCode}");

  // Custom options (not logged)
  final customResult = await client.getWithOptions("https://www.google.com",
      options: [LogOptions(isEnabled: false)]);
  print("default status code: ${customResult.statusCode}");
}
```

## Conventions

If you create an extension package, please follow those naming conventions :

* `http_extensions_<name>` : package name 
* `<Name>Extension` : extension class 
* `<Name>Options` : options class.

`<name>` : camelCase

`<Name>` : PascalCase

[See a log example](example/log_extension.dart)

## Q & A

> How is this compare to [dio](https://pub.dev/packages/dio) ?

Dio does a lot more, but it doesn't integrate well over web. That's why I just wanted a thin layer on top of http package, which is an officially supported package, compatible with native platforms, but also with web browsers.
