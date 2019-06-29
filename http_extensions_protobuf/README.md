# http_extensions : protobuf

An [http extension] that serializes requests body to protobuf and deserializes responses's content from protobuf.

## Usage

```dart
final client = ExtendedClient(
  inner: Client(),
  extensions: [
    ProtobufExtension(logger: Logger("Protobuf"),
    defaultOptions: ProtobufOptions(
      contentType: "application/x-protobuf", // The value of the content type header sent to server.
      shouldDeserialize: (response) => response.statusCode >= 200 && response.statusCode < 300, // Indicates whether a response should be deserialized
      shouldSerialize: (request) => true, // Indicates whether a request should be serialized
    )),
  ],
);

// The new request will serialize requestMessage to body and responseMessage from response content
final proto = ProtobufOptions(
  requestMessage: HelloRequest(),
  responseMessage: HelloReply(),
);

final response = await client.postWithOptions(
  "http://www.flutter.dev",
  options: [proto],
);

if (response.statusCode == 200) {
  print("Reply: ${proto.responseMessage}");
}
```