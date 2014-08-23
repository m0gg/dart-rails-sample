part of benchmark;

abstract class Benchmark {
  String bname = "unclassified";

  Future<BenchmarkResult> runAsync() {
    Future<BenchmarkResult> result = new Future<BenchmarkResult>(() {
      BenchmarkResult res = new BenchmarkResult(bname)
        ..start();
      res.finish(run());
      return res;
    });
    return result;
  }

  dynamic run();
}
