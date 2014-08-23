part of benchmark;

class IOWriteBenchmark extends Benchmark {
  String bname = "IO Write";
  Storage store;
  List seed;

  IOWriteBenchmark(this.store, this.seed);

  Storage run() {
    for(int i = 0; i < seed.length; i++) {
      store[i.toString()] = seed[i].toString();
    }
    return store;
  }
}

class IOReadBenchmark extends Benchmark {
  String bname = "IO Read";
  Storage store;

  IOReadBenchmark(this.store);

  Storage run() {
    String x;
    store.forEach((key, value) => x = value);
    return store;
  }
}
