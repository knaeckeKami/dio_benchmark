import 'dart:typed_data';

import 'package:dio/dio.dart';

class FakeAdapter implements HttpClientAdapter {
  final Uint8List bytes;

  FakeAdapter(this.bytes);

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) {
    return Future.value(
      ResponseBody.fromBytes(bytes, 200, headers: {
        'content-type': ['application/json']
      }),
    );
  }
}
