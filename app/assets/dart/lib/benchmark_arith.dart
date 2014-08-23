part of benchmark;

class ArithmeticBenchmark extends Benchmark {
  String bname = "Arithmetic";

  ArithmeticBenchmark();

  List<double> run() {
    List<double> results = new List<double>(200000);
    Random fac = new Random();
    double pre = 1.0;
    for(int i = 0; i < 200000; i++) {
      results[i] = pre = PI * i + pre * fac.nextDouble();
    }
    return results;
  }

  Future<BenchmarkResult<List<double>>> runAsync() {
    return super.runAsync();
  }
}

class ArithmeticSIMDBenchmark extends Benchmark {
  String bname = "ArithmeticSIMD";

  ArithmeticSIMDBenchmark();

  Float32x4List run() {
    Float32x4List results = new Float32x4List(50000);
    Random fac = new Random();
    double pre = 1.0;
    Float32x4 iv, facv, prev = new Float32x4(pre, pre, pre, pre), pi = new Float32x4(PI, PI, PI, PI);
    for(int i = 0; i < 50000; i++) {
      iv = new Float32x4(i.toDouble(), i + 1.0, i + 2.0, i + 3.0);
      facv = new Float32x4(fac.nextDouble(), fac.nextDouble(), fac.nextDouble(), fac.nextDouble());
      prev = pi * iv + prev * facv;
      results[i] = prev;
    }
    return results;
  }

  Future<BenchmarkResult<Float32x4List>> runAsync() {
    return super.runAsync();
  }
}
