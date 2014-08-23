part of benchmark;

class JSONEncodeBenchmark extends Benchmark {
  String bname = "JSON Encode";
  List seed;

  JSONEncodeBenchmark(this.seed);

  String run() {
    return JSON.encode(seed);
  }

  Future<BenchmarkResult<String>> runAsync() {
    return super.runAsync();
  }
}

class JSONDecodeBenchmark extends Benchmark {
  String bname = "JSON Decode";
  String seed;

  JSONDecodeBenchmark(this.seed);

  bool run() {
    JSON.decode(seed);
    return true;
  }

  Future<BenchmarkResult<bool>> runAsync() {
    return super.runAsync();
  }
}
