# dio_benchmark

A simple benchmark for improved dio transformers.

Takes advantage of a hidden `Convert` that we get when fusing utf8 with json.
see https://github.com/dart-lang/sdk/blob/5b2ea0c7a227d91c691d2ff8cbbeb5f7f86afdb9/sdk/lib/_internal/vm/lib/convert_patch.dart#L54 

Example on AOT:
```
Run dart compile exe lib/dio_benchmark.dart && lib/dio_benchmark.exe
Generated: /home/runner/work/dio_benchmark/dio_benchmark/lib/dio_benchmark.exe
File           SyncTransformer (μs) UTF8JsonTransformer (μs) Relative Improvement utf8json/sync 
tiny.json                     37.76                    37.69                               1.00 
1KB.json                      81.34                    51.15                               1.59 
4KB.json                     183.51                    90.30                               2.03 
64KB.json                  2,816.20                   278.35                              10.12 
128KB-min.json            11,345.64                   896.53                              12.66 
1MB.json                  44,305.52                 3,661.16                              12.10 
5MB.json                 229,519.44                18,243.91                              12.58 
```

JIT:

```
Run dart lib/dio_benchmark.dart
File           SyncTransformer (μs) UTF8JsonTransformer (μs) Relative Improvement utf8json/sync 
tiny.json                     43.34                    69.51                               0.62 
1KB.json                      76.71                    63.28                               1.21 
4KB.json                     156.31                    88.31                               1.77 
64KB.json                  2,452.30                   299.32                               8.19 
128KB-min.json             9,347.76                   984.85                               9.49 
1MB.json                  36,157.88                 3,872.01                               9.34 
5MB.json                 185,092.73                19,315.58                               9.58 
  
```
