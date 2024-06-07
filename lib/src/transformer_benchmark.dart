import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dio/dio.dart';
import 'package:dio_benchmark/src/fake_adapter.dart';

class TransformerBenchmark extends AsyncBenchmarkBase {
  final Uint8List bytes;
  final Transformer transformer;

  TransformerBenchmark(this.bytes, this.transformer, String name)
      : super('SyncTransformerBenchmark: $name');

  late Dio dio;

  @override
  Future<void> setup() async {
    dio = Dio();
    dio.httpClientAdapter = FakeAdapter(bytes);
    dio.transformer = transformer;
  }

  @override
  Future<void> warmup() async {
    await dio.get('http://example.com');
  }

  @override
  Future<void> run() async {
    final response = await dio.get('http://example.com');
    response.data;
  }

  @override
  Future<void> teardown() async {
    dio.close();
  }
}
