import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class UTF8JsonTransformer extends SyncTransformer {
  /// on vw, this creates a special fast decoder.
  /// see https://github.com/dart-lang/sdk/blob/5b2ea0c7a227d91c691d2ff8cbbeb5f7f86afdb9/sdk/lib/_internal/vm/lib/convert_patch.dart#L54
  final decoder = const Utf8Decoder().fuse(const JsonDecoder());

  UTF8JsonTransformer();

  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    final responseType = options.responseType;
    // Do not handled the body for streams.
    if (responseType == ResponseType.stream) {
      return responseBody;
    }

    // Return the finalized bytes if the response type is bytes.
    if (responseType == ResponseType.bytes) {
      final chunks = await responseBody.stream.toList();
      final responseBytes =
          Uint8List.fromList(chunks.expand((c) => c).toList());
      return responseBytes;
    }

    final isJsonContent = Transformer.isJsonMimeType(
      responseBody.headers[Headers.contentTypeHeader]?.first,
    );

    if (isJsonContent) {
      final stream = responseBody.stream;
      final decodedStream = decoder.bind(stream);
      final decoded = await decodedStream.toList();
      assert(decoded.length == 1);
      return decoded.first;
    }

    // If the response is not JSON, we should return the response as a string

    final chunks = await responseBody.stream.toList();
    final responseBytes = Uint8List.fromList(chunks.expand((c) => c).toList());

    return utf8.decode(responseBytes, allowMalformed: true);
  }
}
