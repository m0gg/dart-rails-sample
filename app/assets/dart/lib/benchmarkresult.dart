part of benchmark;

class BenchmarkResult<T> {
  Duration runtime;
  T returnValue;
  Stopwatch _timer;
  String bname;

  BenchmarkResult(this.bname) {
    _timer = new Stopwatch();
  }

  void start() {
    _timer.start();
  }

  String export() {
    StringBuffer ret = new StringBuffer();
    int rt = runtime.inMilliseconds;
    ret.write("$bname; $rt \n");
    return ret.toString();
  }

  void finish(T result) {
    _timer.stop();
    returnValue = result;
    runtime = _timer.elapsed;
  }
}
