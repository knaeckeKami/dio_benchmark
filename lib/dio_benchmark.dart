import 'dart:async';
import 'dart:io';

import 'package:barbecue/barbecue.dart';
import 'package:dio/dio.dart';
import 'package:dio_benchmark/src/transformer_benchmark.dart';
import 'package:dio_benchmark/src/utf8jsonTransformer.dart';
import 'package:intl/intl.dart';

class BenchMarkResult {
  final String fileName;
  final double syncTime;
  final double optimizedTime;

  BenchMarkResult(this.fileName, this.syncTime, this.optimizedTime);
}

void main() async {
  const fileNames = [
    'tiny.json',
    '1KB.json',
    '4KB.json',
    '64KB.json',
    '128KB-min.json',
    '1MB.json',
    '5MB.json',
  ];

  final results = await _runBenchmarks(fileNames);

  final table = _createTable(results);

  print(table.render());
}

Future<List<BenchMarkResult>> _runBenchmarks(List<String> fileNames) async {
  final results = <BenchMarkResult>[];

  for (final fileName in fileNames) {
    final bytes = File('assets/$fileName').readAsBytesSync();
    final benchmark2 = TransformerBenchmark(
        bytes, UTF8JsonTransformer(), "utf8json: $fileName");
    final optimizedTime = await benchmark2.measure();
    final benchmark =
        TransformerBenchmark(bytes, SyncTransformer(), "sync:     $fileName");
    final syncTime = await benchmark.measure();

    results.add(BenchMarkResult(fileName, syncTime, optimizedTime));
  }

  return results;
}

Table _createTable(List<BenchMarkResult> results) {
  final nf =
      NumberFormat.decimalPatternDigits(locale: 'en_US', decimalDigits: 2);
  return Table(
      header: TableSection(rows: [
        Row(cellStyle: CellStyle(paddingRight: 1), cells: [
          Cell('File'),
          Cell('SyncTransformer (μs)'),
          Cell('UTF8JsonTransformer (μs)'),
          Cell('Relative Improvement utf8json/sync'),
        ]),
      ]),
      body: TableSection(rows: [
        ...results
            .map((e) => Row(cellStyle: CellStyle(paddingRight: 1), cells: [
                  Cell(e.fileName),
                  Cell(nf.format(e.syncTime),
                      style: CellStyle(alignment: TextAlignment.MiddleRight)),
                  Cell(nf.format(e.optimizedTime),
                      style: CellStyle(alignment: TextAlignment.MiddleRight)),
                  Cell(
                      nf.format(
                        (e.syncTime / e.optimizedTime),
                      ),
                      style: CellStyle(alignment: TextAlignment.MiddleRight))
                ]))
      ]));
}
